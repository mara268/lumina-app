// Ponte do Lúmina: deixa o jogo funcionar com a maquete em QUALQUER celular,
// inclusive iPhone, pelo navegador.
//
// O que ela faz, rodando no notebook:
//   1. entrega o jogo (a pasta build/web) para os celulares da rede;
//   2. repassa os comandos do jogo (/maquete/...) para o ESP32 da maquete.
//
// Como usar (num terminal, dentro da pasta do projeto):
//   flutter build web --release
//   dart run tool/ponte.dart
//
// Opcional: dart run tool/ponte.dart <ip_da_maquete> <porta>
//   (padrão: 192.168.4.1 e 8080)

import 'dart:async';
import 'dart:convert';
import 'dart:io';

const Map<String, String> _tipos = {
  'html': 'text/html; charset=utf-8',
  'js': 'application/javascript',
  'mjs': 'application/javascript',
  'json': 'application/json',
  'wasm': 'application/wasm',
  'css': 'text/css',
  'png': 'image/png',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'svg': 'image/svg+xml',
  'ico': 'image/x-icon',
  'ttf': 'font/ttf',
  'otf': 'font/otf',
  'woff2': 'font/woff2',
  'txt': 'text/plain; charset=utf-8',
  'twee': 'text/plain; charset=utf-8',
};

Future<void> main(List<String> args) async {
  final ipMaquete = args.isNotEmpty ? args[0] : '192.168.4.1';
  final porta = args.length > 1 ? int.parse(args[1]) : 8080;

  final pasta = Directory('build/web');
  if (!pasta.existsSync()) {
    stderr.writeln('Não encontrei a pasta build/web.');
    stderr.writeln('Rode antes, neste mesmo terminal:  flutter build web --release');
    exit(1);
  }

  final servidor = await HttpServer.bind(InternetAddress.anyIPv4, porta);
  print('');
  print('Ponte do Lúmina ligada! Maquete em $ipMaquete');
  print('No celular (no mesmo Wi-Fi do notebook), abra no navegador:');
  for (final interface in await NetworkInterface.list(type: InternetAddressType.IPv4)) {
    for (final endereco in interface.addresses) {
      print('   http://${endereco.address}:$porta   (${interface.name})');
    }
  }
  print('Para desligar a ponte, aperte Ctrl+C.');
  print('');

  await for (final pedido in servidor) {
    // a maquete atende um pedido por vez; os outros esperam na fila dela
    unawaited(_atender(pedido, pasta, ipMaquete));
  }
}

Future<void> _atender(HttpRequest pedido, Directory pasta, String ipMaquete) async {
  final resposta = pedido.response;
  try {
    final caminho = pedido.uri.path;
    if (caminho.startsWith('/maquete')) {
      var rota = caminho.substring('/maquete'.length);
      if (rota.isEmpty) rota = '/';
      final auth = pedido.headers.value('authorization') ?? '';
      final codigo = await _pedirAoEsp32(ipMaquete, rota, auth);
      print('maquete $rota -> $codigo');
      resposta.statusCode = codigo == 0 ? 502 : codigo;
      resposta.headers.set('Cache-Control', 'no-store');
      await resposta.close();
      return;
    }

    // arquivos do jogo
    var relativo = Uri.decodeComponent(caminho);
    if (relativo == '/' || relativo.isEmpty) relativo = '/index.html';
    if (relativo.contains('..')) {
      resposta.statusCode = 403;
      await resposta.close();
      return;
    }
    var arquivo = File('${pasta.path}$relativo');
    if (!arquivo.existsSync()) arquivo = File('${pasta.path}/index.html');
    final extensao = arquivo.path.split('.').last.toLowerCase();
    resposta.headers.set('Content-Type', _tipos[extensao] ?? 'application/octet-stream');
    await resposta.addStream(arquivo.openRead());
    await resposta.close();
  } catch (erro) {
    print('erro: $erro');
    try {
      resposta.statusCode = 502;
      await resposta.close();
    } catch (_) {}
  }
}

/// Repassa o pedido ao ESP32 e devolve só o código da resposta
/// (200 = deu certo, 401 = senha errada, 0 = maquete não respondeu).
Future<int> _pedirAoEsp32(String ip, String rota, String auth) async {
  Socket? socket;
  try {
    socket = await Socket.connect(ip, 80, timeout: const Duration(seconds: 5));
    socket.write(
      'GET $rota HTTP/1.1\r\n'
      'Host: $ip\r\n'
      '${auth.isEmpty ? '' : 'Authorization: $auth\r\n'}'
      'Connection: close\r\n'
      '\r\n',
    );
    await socket.flush();
    final bytes = <int>[];
    await socket.listen(bytes.addAll).asFuture<void>().timeout(const Duration(seconds: 12));
    final inicio = latin1.decode(bytes.take(40).toList());
    final codigo = RegExp(r'HTTP/1\.[01] (\d{3})').firstMatch(inicio);
    return codigo == null ? 0 : int.parse(codigo.group(1)!);
  } catch (_) {
    return 0;
  } finally {
    socket?.destroy();
  }
}
