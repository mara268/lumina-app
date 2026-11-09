// =====================================================================
//  SEGREDOS DA MAQUETE (modelo)
//
//  1. Copie este arquivo e renomeie a cópia para:  segredos.h
//  2. Preencha os dados abaixo.
//  3. O segredos.h NUNCA vai para o GitHub (ele está no .gitignore).
// =====================================================================

#pragma once

// --- Código da maquete ---------------------------------------------
// É o "nome" do canal MQTT. O app usa o mesmo código para falar com ela.
// Use letras, números e hífen. Ex.: "lumina-udf-01"
#define ID_MAQUETE "lumina-udf-01"

// --- Servidor MQTT (broker) ----------------------------------------
// TESTE: servidor público e gratuito da HiveMQ (qualquer um pode ver as
// mensagens; use só para testar):
//   MQTT_SERVIDOR "broker.hivemq.com", MQTT_PORTA 1883, MQTT_TLS 0
//
// DEFINITIVO: HiveMQ Cloud (conta gratuita, com usuário e senha):
//   MQTT_SERVIDOR "xxxxxxxx.s1.eu.hivemq.cloud", MQTT_PORTA 8883, MQTT_TLS 1
#define MQTT_SERVIDOR "broker.hivemq.com"
#define MQTT_PORTA    1883
#define MQTT_TLS      0
#define MQTT_USUARIO  ""
#define MQTT_SENHA    ""

// --- Página local da maquete (plano B, sem internet) ---------------
// Rede Wi-Fi criada pela própria maquete e login da página de controle.
#define REDE_MAQUETE_NOME  "ESP32_Casa_Inteligente"
#define REDE_MAQUETE_SENHA "987654321"
#define PAGINA_USUARIO     "admin"
#define PAGINA_SENHA       "1234"
