import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

/// Navegador (inclusive Safari do iPhone): MQTT por WebSocket seguro (wss).
MqttClient criarClienteMqtt(String servidor, int porta, String idCliente) {
  final cliente = MqttBrowserClient('wss://$servidor/mqtt', idCliente);
  cliente.port = porta;
  cliente.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
  return cliente;
}
