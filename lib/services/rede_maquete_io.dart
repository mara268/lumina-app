import 'dart:convert';
import 'dart:io';

/// Celular com o app instalado (Android ou iPhone): fala direto com o ESP32.
///
/// Usa uma conexão "crua" (socket) em vez de um cliente HTTP completo porque o
/// site do ESP32 responde num formato simplificado que alguns clientes recusam.
/// Só precisamos do código da resposta (200 = deu certo, 401 = senha errada).
Future<int> pedirMaquete({
  required String ip,
  required String rota,
  required String autorizacao,
  required Duration limite,
}) async {
  final socket = await Socket.connect(ip, 80, timeout: const Duration(seconds: 5));
  try {
    socket.write(
      'GET $rota HTTP/1.1\r\n'
      'Host: $ip\r\n'
      'Authorization: Basic $autorizacao\r\n'
      'Connection: close\r\n'
      '\r\n',
    );
    await socket.flush();
    final bytes = <int>[];
    // o ESP32 fecha a conexão depois de responder (os motores se mexem antes)
    await socket.listen(bytes.addAll).asFuture<void>().timeout(limite);
    final inicio = latin1.decode(bytes.take(40).toList());
    final codigo = RegExp(r'HTTP/1\.[01] (\d{3})').firstMatch(inicio);
    return codigo == null ? 0 : int.parse(codigo.group(1)!);
  } finally {
    socket.destroy();
  }
}

/// No app instalado, a conexão com a maquete sempre é possível.
bool get redeMaqueteDisponivel => true;

/// No app instalado, o celular fala direto com o IP da maquete.
bool get usaPonte => false;
