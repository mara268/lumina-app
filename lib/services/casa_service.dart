import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../config_maquete.dart';
// MQTT: no navegador usa a versão "web"; no app instalado, a versão "io".
import 'mqtt_cliente_web.dart' if (dart.library.io) 'mqtt_cliente_io.dart' as mqtt_plataforma;
// Wi-Fi local (plano B): idem.
import 'rede_maquete_web.dart' if (dart.library.io) 'rede_maquete_io.dart' as rede;

/// Ações que a maquete (ESP32) entende.
/// [comando] é o texto enviado pelo MQTT; [rota] é o endereço da página local.
enum AcaoCasa {
  abrirPortao('porta/abrir', 'abrindo o portão da garagem'),
  fecharPortao('porta/fechar', 'fechando o portão da garagem'),
  abrirJanela('janela/abrir', 'abrindo a janela'),
  fecharJanela('janela/fechar', 'fechando a janela'),
  abrirCortina('cortina/abrir', 'abrindo a cortina'),
  fecharCortina('cortina/fechar', 'fechando a cortina'),
  ativarAutomatico('auto/ativar', 'ligando a cortina automática'),
  desativarAutomatico('auto/desativar', 'desligando a cortina automática');

  final String comando;
  final String descricao;
  const AcaoCasa(this.comando, this.descricao);

  String get rota => '/$comando';

  static AcaoCasa? porComando(String texto) {
    for (final acao in AcaoCasa.values) {
      if (acao.comando == texto.trim()) return acao;
    }
    return null;
  }
}

/// Como o app fala com a maquete.
enum ModoConexao {
  /// Pela internet, com MQTT (funciona em qualquer celular, sem notebook).
  internet,

  /// Pelo Wi-Fi da própria maquete (plano B, sem internet).
  wifiLocal,
}

/// Canais MQTT de uma maquete.
class TopicosMaquete {
  final String codigo;
  const TopicosMaquete(this.codigo);

  String get comando => 'lumina/$codigo/comando';
  String get estado => 'lumina/$codigo/estado';
  String get online => 'lumina/$codigo/online';
}

/// Conversa com a maquete. Sem conexão, o jogo funciona normalmente (modo simulado).
class CasaService extends ChangeNotifier {
  CasaService._();
  static final CasaService instance = CasaService._();

  ModoConexao modo = ModoConexao.internet;

  // --- Internet (MQTT) ---
  String servidor = ConfigMaquete.servidor;
  int porta = ConfigMaquete.porta;
  String usuarioMqtt = ConfigMaquete.usuario;
  String senhaMqtt = ConfigMaquete.senha;
  String codigoMaquete = ConfigMaquete.codigoMaquete;

  /// true quando a maquete avisou que está ligada; false quando avisou que desligou;
  /// null enquanto não chegou nenhum aviso.
  bool? maqueteOnline;

  /// Último estado publicado pela maquete (portão, janela, cortina, auto).
  Map<String, String> estadoMaquete = {};

  MqttClient? _cliente;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _assinatura;

  // --- Wi-Fi local (plano B) ---
  String ip = '192.168.4.1';
  String usuario = 'admin';
  String senha = '1234';

  // --- Estado geral ---
  bool conectada = false;
  String? ultimoErro;

  /// Ação que está sendo enviada agora (para mostrar na tela).
  AcaoCasa? enviando;

  TopicosMaquete get topicos => TopicosMaquete(codigoMaquete.trim());

  /// Pela internet, funciona em qualquer lugar. Pelo Wi-Fi local, no navegador,
  /// só funciona se o jogo foi aberto pela ponte do notebook (http://).
  bool get suportado => modo == ModoConexao.internet || rede.redeMaqueteDisponivel;

  /// true no navegador em modo Wi-Fi local: os comandos passam pela ponte do notebook.
  bool get usaPonte => modo == ModoConexao.wifiLocal && rede.usaPonte;

  // ===================================================================
  // CONEXÃO
  // ===================================================================

  Future<bool> testar() async {
    await _encerrarMqtt();
    if (modo == ModoConexao.internet) {
      await _conectarMqtt();
    } else {
      await _testarWifiLocal();
    }
    notifyListeners();
    return conectada;
  }

  void desconectar() {
    _encerrarMqtt();
    conectada = false;
    maqueteOnline = null;
    ultimoErro = null;
    notifyListeners();
  }

  Future<void> _conectarMqtt() async {
    final id = 'jogo-${DateTime.now().millisecondsSinceEpoch}';
    final cliente = mqtt_plataforma.criarClienteMqtt(servidor.trim(), porta, id);
    cliente
      ..logging(on: false)
      ..keepAlivePeriod = 30
      ..setProtocolV311()
      ..connectionMessage = MqttConnectMessage().withClientIdentifier(id).startClean()
      ..onDisconnected = _aoCair;

    try {
      final usuario = usuarioMqtt.trim().isEmpty ? null : usuarioMqtt.trim();
      final senha = senhaMqtt.isEmpty ? null : senhaMqtt;
      await cliente.connect(usuario, senha).timeout(const Duration(seconds: 10));
    } catch (_) {
      cliente.disconnect();
    }

    if (cliente.connectionStatus?.state != MqttConnectionState.connected) {
      conectada = false;
      ultimoErro = 'Não consegui entrar no servidor MQTT. Confira a internet, o servidor, o usuário e a senha.';
      return;
    }

    _cliente = cliente;
    conectada = true;
    ultimoErro = null;
    maqueteOnline = null;

    // ouve os avisos da maquete (ligada/desligada e estado dos dispositivos)
    cliente.subscribe(topicos.online, MqttQos.atLeastOnce);
    cliente.subscribe(topicos.estado, MqttQos.atLeastOnce);
    _assinatura = cliente.updates?.listen(_aoReceber);

    // dá um tempinho para o aviso "online" chegar (ele fica guardado no servidor)
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  void _aoReceber(List<MqttReceivedMessage<MqttMessage>> mensagens) {
    for (final mensagem in mensagens) {
      final publicada = mensagem.payload as MqttPublishMessage;
      final texto = MqttPublishPayload.bytesToStringAsString(publicada.payload.message);
      if (mensagem.topic == topicos.online) {
        maqueteOnline = texto.trim() == '1';
      } else if (mensagem.topic == topicos.estado) {
        try {
          final dados = jsonDecode(texto) as Map<String, dynamic>;
          estadoMaquete = dados.map((chave, valor) => MapEntry(chave, '$valor'));
        } catch (_) {
          // mensagem num formato inesperado: ignora
        }
      }
    }
    notifyListeners();
  }

  void _aoCair() {
    if (_cliente == null) return; // desconexão pedida pela própria jogadora
    _cliente = null;
    conectada = false;
    maqueteOnline = null;
    ultimoErro = 'A conexão com o servidor MQTT caiu.';
    notifyListeners();
  }

  Future<void> _encerrarMqtt() async {
    await _assinatura?.cancel();
    _assinatura = null;
    final cliente = _cliente;
    _cliente = null;
    cliente?.disconnect();
  }

  Future<void> _testarWifiLocal() async {
    if (!rede.redeMaqueteDisponivel) {
      conectada = false;
      ultimoErro = 'Neste endereço, o Wi-Fi local não funciona. Use "Pela internet" '
          'ou abra o jogo pela ponte do notebook (endereço http://).';
      return;
    }
    try {
      final codigo = await _pedirLocal('/', const Duration(seconds: 8));
      if (codigo == 200) {
        conectada = true;
        ultimoErro = null;
      } else if (codigo == 401) {
        conectada = false;
        ultimoErro = 'A maquete respondeu, mas o usuário ou a senha estão errados.';
      } else if (codigo == 502 && usaPonte) {
        conectada = false;
        ultimoErro = 'A ponte está ligada, mas não encontrou a maquete. O notebook está no Wi-Fi da maquete?';
      } else {
        conectada = false;
        ultimoErro = 'A maquete respondeu com um erro ($codigo).';
      }
    } catch (_) {
      conectada = false;
      ultimoErro = usaPonte
          ? 'Não encontrei a ponte. Ela está rodando no notebook?'
          : 'Não encontrei a maquete nesse endereço. O celular está no Wi-Fi da maquete?';
    }
  }

  Future<int> _pedirLocal(String rota, Duration limite) => rede.pedirMaquete(
        ip: ip.trim(),
        rota: rota,
        autorizacao: base64Encode(utf8.encode('$usuario:$senha')),
        limite: limite,
      );

  // ===================================================================
  // COMANDOS
  // ===================================================================

  /// Envia as ações em ordem. Se não estiver conectada, não faz nada:
  /// o jogo segue no modo simulado.
  Future<void> enviar(List<AcaoCasa> acoes) async {
    if (!conectada) return;
    for (final acao in acoes) {
      enviando = acao;
      notifyListeners();
      try {
        if (modo == ModoConexao.internet) {
          final cliente = _cliente;
          if (cliente == null) throw StateError('sem cliente');
          final conteudo = MqttClientPayloadBuilder()..addString(acao.comando);
          cliente.publishMessage(topicos.comando, MqttQos.atLeastOnce, conteudo.payload!);
          // a maquete leva uns segundos para mover cada motor
          await Future<void>.delayed(const Duration(milliseconds: 1800));
        } else {
          await _pedirLocal(acao.rota, const Duration(seconds: 12));
        }
      } catch (_) {
        conectada = false;
        ultimoErro = 'A conexão com a maquete caiu.';
        enviando = null;
        notifyListeners();
        return;
      }
    }
    enviando = null;
    notifyListeners();
  }
}
