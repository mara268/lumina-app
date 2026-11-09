/// Configuração padrão da conexão com a maquete pela internet (MQTT).
///
/// Estes valores já aparecem preenchidos na janela "Conectar maquete",
/// para as participantes não precisarem digitar nada.
///
/// TESTE (agora): servidor público e gratuito da HiveMQ. Qualquer pessoa
/// pode ver as mensagens, então use só para testar.
///
/// DEFINITIVO: troque pelo seu servidor do HiveMQ Cloud
/// (ex.: 'xxxxxxxx.s1.eu.hivemq.cloud') e pelo usuário e senha do JOGO
/// (não use o mesmo usuário da maquete).
class ConfigMaquete {
  ConfigMaquete._();

  static const String servidor = 'broker.hivemq.com';
  static const int porta = 8884; // WebSocket seguro (wss)
  static const String usuario = '';
  static const String senha = '';

  /// Tem que ser igual ao ID_MAQUETE do arquivo segredos.h do ESP32.
  static const String codigoMaquete = 'lumina-udf-01';
}
