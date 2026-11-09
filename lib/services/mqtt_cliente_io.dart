import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// App instalado (Android ou iPhone): o mesmo WebSocket seguro (wss) do navegador,
/// assim o mesmo servidor e a mesma porta funcionam em todos os aparelhos.
MqttClient criarClienteMqtt(String servidor, int porta, String idCliente) {
  final cliente = MqttServerClient.withPort('wss://$servidor/mqtt', idCliente, porta);
  cliente.useWebSocket = true;
  cliente.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
  return cliente;
}
