/* =====================================================================
   LÚMINA: CASA INTELIGENTE (ESP32) — versão 10.0 com MQTT

   Baseado no projeto "Automação Residencial com ESP32 9.0 (Cortina Ponte H)".
   Tudo o que existia continua funcionando:
     - portão da garagem (2 servos), janela dupla (2 servos)
     - cortina do quarto (motor DC + mini ponte H)
     - cortina automática pelo sensor de luz (LDR)
     - página de controle local (rede própria da maquete + login)

   Novidades:
     - MQTT: a maquete recebe os comandos do jogo Lúmina pela internet,
       em qualquer celular (inclusive iPhone), sem notebook.
     - WiFiManager: o Wi-Fi do local é escolhido pelo celular, sem regravar a placa.
     - Senhas fora do código principal (arquivo segredos.h).

   Canais MQTT (ID = código da maquete, definido em segredos.h):
     lumina/ID/comando  <- o jogo envia: porta/abrir, porta/fechar,
                           janela/abrir, janela/fechar, cortina/abrir,
                           cortina/fechar, auto/ativar, auto/desativar
     lumina/ID/estado   -> a maquete publica o estado de cada dispositivo
     lumina/ID/online   -> "1" quando ligada, "0" quando desliga (automático)

   Bibliotecas (Arduino IDE > Gerenciador de Bibliotecas):
     - ESP32Servo (Kevin Harrington)
     - PubSubClient (Nick O'Leary)
     - WiFiManager (tzapu)
   ===================================================================== */

#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <ESP32Servo.h>
#include <PubSubClient.h>
#include <WiFiManager.h>
#include <base64.h>
#include "segredos.h"

// ---------------------------------------------------------------------
// Servos
// ---------------------------------------------------------------------
Servo motorGaragem;
Servo motorGaragem2;
Servo motorJanelaEsq;
Servo motorJanelaDir;

// ---------------------------------------------------------------------
// Pinos do ESP32 (iguais à versão 9.0)
// ---------------------------------------------------------------------
const int pinoGaragem = 13;
const int pinoGaragem2 = 32;
const int pinoJanelaEsq = 25;
const int pinoJanelaDir = 26;
const int sensorLDR = 34;
const int pinoCortinaIN1 = 27;  // sentido 1 (abrir)
const int pinoCortinaIN2 = 14;  // sentido 2 (fechar)

// ---------------------------------------------------------------------
// Ângulos e tempos (iguais à versão 9.0)
// ---------------------------------------------------------------------
const int GARAGEM_FECHADA = 0;
const int GARAGEM_ABERTA = 95;
const int JANELA_ESQ_FECHADA = 0;
const int JANELA_DIR_FECHADA = 100;

const int tempoMovimentoCortina = 2000;  // ms girando o motor da cortina

const int LDR_LIMITE_ALTO = 4000;   // acima disso: abre a cortina
const int LDR_LIMITE_BAIXO = 3500;  // abaixo disso: fecha a cortina

const long intervaloLDR = 1000;
unsigned long tempoAnteriorLDR = 0;

// ---------------------------------------------------------------------
// Estado dos dispositivos
// ---------------------------------------------------------------------
String portao = "Fechada";
String cortinaQuarto = "Fechada";
String automaticoCortina = "Ativado";
String statusJanela = "Fechada";

// ---------------------------------------------------------------------
// Página local (plano B)
// ---------------------------------------------------------------------
WiFiServer server(80);
String header;
String credenciaisBase64;
const long timeoutTime = 2000;
unsigned long previousTime = 0;

// ---------------------------------------------------------------------
// MQTT
// ---------------------------------------------------------------------
WiFiClient redeSimples;
WiFiClientSecure redeSegura;
PubSubClient mqtt;

String topicoComando;
String topicoEstado;
String topicoOnline;
unsigned long ultimaTentativaMqtt = 0;

// ===================================================================
// MOTORES
// ===================================================================

void acionarMotorCortina(String acao) {
  if (acao == "abrir") {
    digitalWrite(pinoCortinaIN1, HIGH);
    digitalWrite(pinoCortinaIN2, LOW);
    delay(tempoMovimentoCortina);
  } else if (acao == "fechar") {
    digitalWrite(pinoCortinaIN1, LOW);
    digitalWrite(pinoCortinaIN2, HIGH);
    delay(tempoMovimentoCortina);
  }
  digitalWrite(pinoCortinaIN1, LOW);
  digitalWrite(pinoCortinaIN2, LOW);
}

void abrirJanelaSuave(int speed) {
  for (int pos = 0; pos <= 100; pos++) {
    motorJanelaEsq.write(pos);
    motorJanelaDir.write(100 - pos);
    delay(speed);
  }
}

void fecharJanelaSuave(int speed) {
  for (int pos = 100; pos >= 0; pos--) {
    motorJanelaEsq.write(pos);
    motorJanelaDir.write(100 - pos);
    delay(speed);
  }
}

void moverGaragemSuave(int angle, int speed) {
  int posAtual = motorGaragem.read();
  if (angle > posAtual) {
    for (int p = posAtual; p <= angle; p++) {
      motorGaragem.write(p);
      motorGaragem2.write(100 - p);
      delay(speed);
    }
  } else {
    for (int p = posAtual; p >= angle; p--) {
      motorGaragem.write(p);
      motorGaragem2.write(100 - p);
      delay(speed);
    }
  }
}

// ===================================================================
// ESTADO E COMANDOS (usados pela página local E pelo MQTT)
// ===================================================================

/// Publica o estado atual (fica guardado no servidor para quem conectar depois).
void publicarEstado() {
  if (!mqtt.connected()) return;
  String json = "{\"portao\":\"" + portao + "\",\"janela\":\"" + statusJanela +
                "\",\"cortina\":\"" + cortinaQuarto + "\",\"auto\":\"" + automaticoCortina + "\"}";
  mqtt.publish(topicoEstado.c_str(), json.c_str(), true);
}

/// Executa um comando ("janela/abrir", "porta/fechar"...). Devolve true se entendeu.
bool executarComando(String comando) {
  comando.trim();
  if (comando == "porta/abrir") {
    portao = "Aberta";
    moverGaragemSuave(GARAGEM_ABERTA, 15);
  } else if (comando == "porta/fechar") {
    portao = "Fechada";
    moverGaragemSuave(GARAGEM_FECHADA, 15);
  } else if (comando == "janela/abrir") {
    if (statusJanela != "Aberta") abrirJanelaSuave(15);
    statusJanela = "Aberta";
  } else if (comando == "janela/fechar") {
    if (statusJanela != "Fechada") fecharJanelaSuave(15);
    statusJanela = "Fechada";
  } else if (comando == "cortina/abrir") {
    cortinaQuarto = "Aberta";
    acionarMotorCortina("abrir");
  } else if (comando == "cortina/fechar") {
    cortinaQuarto = "Fechada";
    acionarMotorCortina("fechar");
  } else if (comando == "auto/ativar") {
    automaticoCortina = "Ativado";
  } else if (comando == "auto/desativar") {
    automaticoCortina = "Desativado";
  } else {
    return false;
  }
  Serial.println("Comando executado: " + comando);
  publicarEstado();
  return true;
}

void controlarCortinaAutomatica() {
  if (automaticoCortina == "Desativado") return;
  if (millis() - tempoAnteriorLDR < intervaloLDR) return;
  tempoAnteriorLDR = millis();

  int valorLDR = analogRead(sensorLDR);
  if (valorLDR > LDR_LIMITE_ALTO && cortinaQuarto != "Aberta") {
    cortinaQuarto = "Aberta";
    acionarMotorCortina("abrir");
    publicarEstado();
  } else if (valorLDR < LDR_LIMITE_BAIXO && cortinaQuarto != "Fechada") {
    cortinaQuarto = "Fechada";
    acionarMotorCortina("fechar");
    publicarEstado();
  }
}

// ===================================================================
// MQTT
// ===================================================================

void aoReceberMensagem(char* topico, byte* conteudo, unsigned int tamanho) {
  String comando;
  for (unsigned int i = 0; i < tamanho; i++) comando += (char)conteudo[i];
  Serial.println("MQTT recebeu: " + comando);
  executarComando(comando);
}

/// Tenta (re)conectar ao servidor MQTT sem travar a maquete.
void manterMqtt() {
  if (WiFi.status() != WL_CONNECTED) return;
  if (mqtt.connected()) {
    mqtt.loop();
    return;
  }
  if (millis() - ultimaTentativaMqtt < 5000) return;
  ultimaTentativaMqtt = millis();

  String idCliente = String("maquete-") + ID_MAQUETE + "-" + String((uint32_t)ESP.getEfuseMac(), HEX);
  Serial.print("Conectando ao MQTT... ");
  // "testamento": se a maquete cair, o servidor avisa sozinho que ela está offline
  // servidor de teste: sem usuário e senha (NULL); HiveMQ Cloud: com usuário e senha
  const char* usuario = strlen(MQTT_USUARIO) > 0 ? MQTT_USUARIO : NULL;
  const char* senha = strlen(MQTT_SENHA) > 0 ? MQTT_SENHA : NULL;
  bool ok = mqtt.connect(idCliente.c_str(), usuario, senha,
                         topicoOnline.c_str(), 1, true, "0");
  if (ok) {
    Serial.println("conectado!");
    mqtt.publish(topicoOnline.c_str(), "1", true);
    mqtt.subscribe(topicoComando.c_str(), 1);
    publicarEstado();
  } else {
    Serial.print("falhou, código ");
    Serial.println(mqtt.state());
  }
}

// ===================================================================
// PÁGINA LOCAL (plano B, igual à versão 9.0)
// ===================================================================

void enviarPaginaHTML(WiFiClient &client) {
  client.println("HTTP/1.1 200 OK\nContent-type:text/html\nConnection: close\n");
  client.println("<!DOCTYPE html><html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1'>");
  client.println("<style>");
  client.println(":root { --bg: #f2f2f2; --card: #ffffff; --text: #222222; --shadow: rgba(0,0,0,0.1); }");
  client.println("body.dark { --bg: #121212; --card: #1f1f1f; --text: #f5f5f5; --shadow: rgba(255,255,255,0.05); }");
  client.println("body { font-family: sans-serif; text-align: center; background-color: var(--bg); color: var(--text); padding: 20px; margin: 0; }");
  client.println(".card { background: var(--card); padding: 20px; border-radius: 15px; margin: 0 auto 15px auto; max-width: 400px; box-shadow: 0 4px 8px var(--shadow); }");
  client.println(".btn { display: inline-block; padding: 15px 30px; color: white; text-decoration: none; border-radius: 8px; margin: 5px; font-weight: bold; }");
  client.println(".on { background: #4CAF50; } .off { background: #f44336; } .auto { background: #2196F3; }");
  client.println(".theme-btn { background: #555; color: white; padding: 10px 20px; border-radius: 8px; border: none; font-size: 16px; margin-top: 10px; }");
  client.println("</style></head><body>");
  client.println("<h1>CASA INTELIGENTE</h1>");
  client.println("<p>MQTT: " + String(mqtt.connected() ? "conectado" : "desconectado") + "</p>");
  client.println("<button class='theme-btn' onclick='alternarTema()'>Modo Claro/Escuro</button><br><br>");
  client.println("<div class='card'><h2>Portão Garagem: " + portao + "</h2>");
  client.println("<a href='/porta/abrir' class='btn on'>ABRIR</a><a href='/porta/fechar' class='btn off'>FECHAR</a></div>");
  client.println("<div class='card'><h2>Janela Dupla: " + statusJanela + "</h2>");
  client.println("<a href='/janela/abrir' class='btn on'>ABRIR</a><a href='/janela/fechar' class='btn off'>FECHAR</a></div>");
  client.println("<div class='card'><h2>Cortina Quarto: " + cortinaQuarto + "</h2>");
  client.println("<p>Automático: " + automaticoCortina + "</p>");
  client.println("<a href='/cortina/abrir' class='btn on'>ABRIR</a><a href='/cortina/fechar' class='btn off'>FECHAR</a><br><br>");
  if (automaticoCortina == "Ativado") {
    client.println("<a href='/auto/desativar' class='btn off'>DESATIVAR AUTO</a>");
  } else {
    client.println("<a href='/auto/ativar' class='btn auto'>ATIVAR AUTO</a>");
  }
  client.println("</div>");
  client.println("<script>");
  client.println("function alternarTema(){document.body.classList.toggle('dark');localStorage.setItem('tema',document.body.classList.contains('dark')?'escuro':'claro');}");
  client.println("window.onload=function(){if(localStorage.getItem('tema')==='escuro'){document.body.classList.add('dark');}};");
  client.println("</script></body></html>");
}

void atenderPaginaLocal() {
  WiFiClient client = server.available();
  if (!client) return;

  String currentLine = "";
  unsigned long currentTime = millis();
  previousTime = currentTime;

  while (client.connected() && currentTime - previousTime <= timeoutTime) {
    currentTime = millis();
    if (!client.available()) continue;
    char c = client.read();
    header += c;
    if (c == '\n') {
      if (currentLine.length() == 0) {
        String authHeader = "Authorization: Basic " + credenciaisBase64;
        if (header.indexOf(authHeader) >= 0) {
          // os endereços da página são os mesmos comandos do MQTT
          const char* comandos[] = {"porta/abrir", "porta/fechar", "janela/abrir", "janela/fechar",
                                    "cortina/abrir", "cortina/fechar", "auto/ativar", "auto/desativar"};
          for (const char* comando : comandos) {
            if (header.indexOf(String("GET /") + comando) >= 0) {
              executarComando(comando);
              break;
            }
          }
          enviarPaginaHTML(client);
        } else {
          client.println("HTTP/1.1 401 Unauthorized");
          client.println("WWW-Authenticate: Basic realm=\"Acesso Restrito Smart Home\"");
          client.println("Content-type:text/html");
          client.println("Connection: close");
          client.println();
          client.println("<!DOCTYPE html><html><body><h1>401 - Acesso Negado</h1></body></html>");
        }
        break;
      } else {
        currentLine = "";
      }
    } else if (c != '\r') {
      currentLine += c;
    }
  }
  header = "";
  client.stop();
}

// ===================================================================
// SETUP E LOOP
// ===================================================================

void setup() {
  Serial.begin(115200);

  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  ESP32PWM::allocateTimer(2);
  ESP32PWM::allocateTimer(3);

  pinMode(sensorLDR, INPUT);
  pinMode(pinoCortinaIN1, OUTPUT);
  pinMode(pinoCortinaIN2, OUTPUT);
  digitalWrite(pinoCortinaIN1, LOW);
  digitalWrite(pinoCortinaIN2, LOW);

  motorGaragem.setPeriodHertz(50);
  motorGaragem.attach(pinoGaragem, 500, 2400);
  motorGaragem2.setPeriodHertz(50);
  motorGaragem2.attach(pinoGaragem2, 500, 2400);
  motorJanelaEsq.setPeriodHertz(50);
  motorJanelaEsq.attach(pinoJanelaEsq, 500, 2400);
  motorJanelaDir.setPeriodHertz(50);
  motorJanelaDir.attach(pinoJanelaDir, 500, 2400);

  motorGaragem.write(GARAGEM_FECHADA);
  motorGaragem2.write(GARAGEM_FECHADA);
  motorJanelaEsq.write(JANELA_ESQ_FECHADA);
  motorJanelaDir.write(JANELA_DIR_FECHADA);

  credenciaisBase64 = base64::encode(String(PAGINA_USUARIO) + ":" + PAGINA_SENHA);

  // --- Wi-Fi com internet (escolhido pelo celular) ---
  // Na primeira vez (ou se a rede salva não existir), a maquete cria a rede
  // "Lumina_Config". Conecte o celular nela e escolha o Wi-Fi do local.
  WiFiManager wm;
  wm.setConfigPortalTimeout(180);  // depois de 3 minutos, segue sem internet
  bool temInternet = wm.autoConnect("Lumina_Config");
  Serial.println(temInternet ? "Wi-Fi conectado: " + WiFi.localIP().toString()
                             : "Sem Wi-Fi com internet: só a página local vai funcionar.");

  // --- Rede própria da maquete (página local, plano B) ---
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAP(REDE_MAQUETE_NOME, REDE_MAQUETE_SENHA);
  Serial.print("Página local em http://");
  Serial.println(WiFi.softAPIP());
  server.begin();

  // --- MQTT ---
  topicoComando = String("lumina/") + ID_MAQUETE + "/comando";
  topicoEstado = String("lumina/") + ID_MAQUETE + "/estado";
  topicoOnline = String("lumina/") + ID_MAQUETE + "/online";
  if (MQTT_TLS) {
    redeSegura.setInsecure();  // conexão criptografada, sem conferir o certificado
    mqtt.setClient(redeSegura);
  } else {
    mqtt.setClient(redeSimples);
  }
  mqtt.setServer(MQTT_SERVIDOR, MQTT_PORTA);
  mqtt.setCallback(aoReceberMensagem);
  mqtt.setKeepAlive(30);
}

void loop() {
  manterMqtt();
  controlarCortinaAutomatica();
  atenderPaginaLocal();
}
