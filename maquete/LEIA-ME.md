# Maquete do Lúmina (ESP32 + MQTT)

Código da casa inteligente em MDF. A maquete recebe os comandos do jogo
pela internet, usando MQTT, e funciona com qualquer celular (inclusive iPhone).

```
Jogo (celular)  →  servidor MQTT (nuvem)  →  maquete (ESP32)
```

## O que tem na maquete

| Dispositivo | Pino do ESP32 | Comando MQTT |
|---|---|---|
| Portão da garagem (2 servos) | 13 e 32 | `porta/abrir`, `porta/fechar` |
| Janela dupla (2 servos) | 25 e 26 | `janela/abrir`, `janela/fechar` |
| Cortina do quarto (motor DC + ponte H) | 27 e 14 | `cortina/abrir`, `cortina/fechar` |
| Cortina automática (sensor de luz LDR) | 34 | `auto/ativar`, `auto/desativar` |

## Canais MQTT

`ID` é o código da maquete (definido no `segredos.h` e no app).

| Canal | Quem publica | Conteúdo |
|---|---|---|
| `lumina/ID/comando` | jogo | um dos comandos da tabela acima |
| `lumina/ID/estado` | maquete | `{"portao":"Aberta","janela":"Fechada","cortina":"Fechada","auto":"Ativado"}` |
| `lumina/ID/online` | maquete | `1` ligada, `0` desligada (aviso automático) |

## Passo 1: preparar o computador (uma vez só)

1. Instale o **Arduino IDE** (arduino.cc).
2. Em **Arquivo → Preferências → URLs adicionais**, cole:
   `https://espressif.github.io/arduino-esp32/package_esp32_index.json`
3. Em **Ferramentas → Placa → Gerenciador de Placas**, instale **esp32 (Espressif)**.
4. Em **Ferramentas → Gerenciar Bibliotecas**, instale:
   - **ESP32Servo** (Kevin Harrington)
   - **PubSubClient** (Nick O'Leary)
   - **WiFiManager** (tzapu)

## Passo 2: configurar as senhas

1. Na pasta `lumina_casa_mqtt`, copie `segredos.exemplo.h` e renomeie a cópia para `segredos.h`.
2. Para **testar**, pode deixar como está (servidor público da HiveMQ).
3. O `ID_MAQUETE` precisa ser **igual** ao "Código da maquete" do app
   (arquivo `lib/config_maquete.dart`).

O `segredos.h` não vai para o GitHub.

## Passo 3: gravar na placa

1. Abra `lumina_casa_mqtt/lumina_casa_mqtt.ino` no Arduino IDE.
2. Ligue o ESP32 no computador pelo cabo USB.
3. Em **Ferramentas → Placa**, escolha **ESP32 Dev Module**.
4. Em **Ferramentas → Porta**, escolha a porta que apareceu (ex.: COM3).
5. Clique em **Carregar** (seta →). Se travar em "Connecting...", segure o botão **BOOT** da placa até começar.
6. Abra o **Monitor Serial** (115200) para ver as mensagens da maquete.

## Passo 4: escolher o Wi-Fi do local (sem regravar)

1. Ligue a maquete. Se ela não conhecer nenhum Wi-Fi, cria a rede **Lumina_Config**.
2. No celular, conecte-se a **Lumina_Config**. Uma página abre sozinha (se não abrir, acesse `192.168.4.1`).
3. Toque em **Configure WiFi**, escolha a rede do local e digite a senha.
4. A maquete reinicia já conectada. Nas próximas vezes, ela lembra a rede.

Se em 3 minutos ninguém configurar, a maquete segue sem internet: só a página local funciona.

## Passo 5: testar com o jogo

1. No jogo, toque em **Conectar maquete** → **Internet** → **CONECTAR**.
2. Deve aparecer "Maquete conectada!". Jogue as fases e veja a maquete se mexer.

## Plano B: sem internet

A página de controle antiga continua funcionando:
conecte o celular à rede **ESP32_Casa_Inteligente** e acesse `http://192.168.4.1`
(usuário e senha definidos no `segredos.h`).

## Passo 6 (definitivo): servidor próprio no HiveMQ Cloud

O servidor de teste é público: qualquer pessoa pode ver e mandar mensagens.
Para o uso definitivo:

1. Crie uma conta gratuita em **console.hivemq.cloud** e um cluster **Serverless (Free)**.
2. Em **Access Management**, crie dois usuários: um para a **maquete** e outro para o **jogo**.
3. No `segredos.h` da maquete: `MQTT_SERVIDOR` = endereço do cluster,
   `MQTT_PORTA 8883`, `MQTT_TLS 1`, usuário e senha **da maquete**. Grave de novo na placa.
4. No app, em `lib/config_maquete.dart`: `servidor` = endereço do cluster,
   `porta = 8884`, usuário e senha **do jogo**.

A senha do jogo fica visível para quem inspecionar o código da página. Por isso
o usuário do jogo deve ter permissão só para publicar em `lumina/ID/comando`
e ler `lumina/ID/estado` e `lumina/ID/online`.
