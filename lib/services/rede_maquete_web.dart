import 'package:http/http.dart' as http;

/// Navegador (inclusive o Safari do iPhone): o navegador não deixa a página
/// falar direto com o ESP32, então ela fala com a "ponte" (tool/ponte.dart),
/// que roda no notebook, entrega o jogo e repassa os comandos para a maquete.
/// Os comandos vão para o mesmo endereço do jogo, em /maquete/...
Future<int> pedirMaquete({
  required String ip,
  required String rota,
  required String autorizacao,
  required Duration limite,
}) async {
  final endereco = Uri.base.resolve('/maquete$rota');
  final resposta = await http
      .get(endereco, headers: {'Authorization': 'Basic $autorizacao'})
      .timeout(limite);
  return resposta.statusCode;
}

/// Só funciona quando o jogo foi aberto pela ponte (endereço http://, não https://).
/// No GitHub Pages (https) o jogo fica no modo simulado.
bool get redeMaqueteDisponivel => Uri.base.scheme == 'http';

/// No navegador, os comandos passam pela ponte do notebook.
bool get usaPonte => true;
