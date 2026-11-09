import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../services/casa_service.dart';
import '../services/mqtt_cliente_web.dart' if (dart.library.io) '../services/mqtt_cliente_io.dart'
    as mqtt_plataforma;

/// Simulador da maquete: finge ser o ESP32.
///
/// Abra em outro celular ou em outra aba do navegador. Ele entra no mesmo
/// canal MQTT da maquete, avisa que está "ligado", recebe os comandos do jogo
/// e mostra o portão, a janela e a cortina mudando, do mesmo jeito que a
/// maquete de verdade faria. Serve para testar tudo sem o hardware.
class SimuladorMaqueteScreen extends StatefulWidget {
  const SimuladorMaqueteScreen({super.key});

  @override
  State<SimuladorMaqueteScreen> createState() => _SimuladorMaqueteScreenState();
}

class _SimuladorMaqueteScreenState extends State<SimuladorMaqueteScreen> {
  final _casa = CasaService.instance;
  MqttClient? _cliente;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _assinatura;

  bool _conectando = true;
  String? _erro;

  // estado igual ao do ESP32
  String _portao = 'Fechada';
  String _janela = 'Fechada';
  String _cortina = 'Fechada';
  String _auto = 'Ativado';

  final List<String> _historico = [];

  TopicosMaquete get _topicos => _casa.topicos;

  @override
  void initState() {
    super.initState();
    _ligar();
  }

  @override
  void dispose() {
    _desligar();
    super.dispose();
  }

  Future<void> _ligar() async {
    final id = 'simulador-${DateTime.now().millisecondsSinceEpoch}';
    final cliente = mqtt_plataforma.criarClienteMqtt(_casa.servidor.trim(), _casa.porta, id);
    cliente
      ..logging(on: false)
      ..keepAlivePeriod = 30
      ..setProtocolV311()
      // "testamento": se o simulador fechar, o servidor avisa que a maquete desligou
      ..connectionMessage = MqttConnectMessage()
          .withClientIdentifier(id)
          .withWillTopic(_topicos.online)
          .withWillMessage('0')
          .withWillQos(MqttQos.atLeastOnce)
          .withWillRetain()
          .startClean();

    try {
      final usuario = _casa.usuarioMqtt.trim().isEmpty ? null : _casa.usuarioMqtt.trim();
      final senha = _casa.senhaMqtt.isEmpty ? null : _casa.senhaMqtt;
      await cliente.connect(usuario, senha).timeout(const Duration(seconds: 10));
    } catch (_) {
      cliente.disconnect();
    }

    if (!mounted) return;
    if (cliente.connectionStatus?.state != MqttConnectionState.connected) {
      setState(() {
        _conectando = false;
        _erro = 'Não consegui entrar no servidor MQTT. Confira a internet e os dados do servidor.';
      });
      return;
    }

    _cliente = cliente;
    cliente.subscribe(_topicos.comando, MqttQos.atLeastOnce);
    _assinatura = cliente.updates?.listen(_aoReceber);
    _publicar(_topicos.online, '1');
    _publicarEstado();
    setState(() {
      _conectando = false;
      _historico.insert(0, 'Simulador ligado no canal ${_topicos.comando}');
    });
  }

  void _desligar() {
    _assinatura?.cancel();
    final cliente = _cliente;
    _cliente = null;
    if (cliente != null) {
      _publicar(_topicos.online, '0', cliente: cliente);
      cliente.disconnect();
    }
  }

  void _publicar(String topico, String texto, {MqttClient? cliente}) {
    final alvo = cliente ?? _cliente;
    if (alvo == null) return;
    final conteudo = MqttClientPayloadBuilder()..addString(texto);
    alvo.publishMessage(topico, MqttQos.atLeastOnce, conteudo.payload!, retain: true);
  }

  void _publicarEstado() {
    _publicar(
      _topicos.estado,
      jsonEncode({'portao': _portao, 'janela': _janela, 'cortina': _cortina, 'auto': _auto}),
    );
  }

  void _aoReceber(List<MqttReceivedMessage<MqttMessage>> mensagens) {
    for (final mensagem in mensagens) {
      if (mensagem.topic != _topicos.comando) continue;
      final publicada = mensagem.payload as MqttPublishMessage;
      final texto = MqttPublishPayload.bytesToStringAsString(publicada.payload.message).trim();
      final acao = AcaoCasa.porComando(texto);
      if (!mounted) return;
      setState(() {
        switch (acao) {
          case AcaoCasa.abrirPortao:
            _portao = 'Aberta';
          case AcaoCasa.fecharPortao:
            _portao = 'Fechada';
          case AcaoCasa.abrirJanela:
            _janela = 'Aberta';
          case AcaoCasa.fecharJanela:
            _janela = 'Fechada';
          case AcaoCasa.abrirCortina:
            _cortina = 'Aberta';
          case AcaoCasa.fecharCortina:
            _cortina = 'Fechada';
          case AcaoCasa.ativarAutomatico:
            _auto = 'Ativado';
          case AcaoCasa.desativarAutomatico:
            _auto = 'Desativado';
          case null:
            break;
        }
        final hora = TimeOfDay.now().format(context);
        _historico.insert(0, acao == null ? '$hora  comando desconhecido: "$texto"' : '$hora  $texto');
      });
      if (acao != null) _publicarEstado();
    }
  }

  Widget _dispositivo(String nome, String estado, IconData aberto, IconData fechado) {
    final estaAberto = estado == 'Aberta';
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Icon(
                  estaAberto ? aberto : fechado,
                  key: ValueKey(estado),
                  size: 46,
                  color: estaAberto ? const Color(0xFFE65100) : const Color(0xFF546E7A),
                ),
              ),
              const SizedBox(height: 6),
              Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(estado, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador da maquete'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_conectando)
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else if (_erro != null)
                Text(_erro!, style: const TextStyle(color: Color(0xFFE53935)))
              else ...[
                Text(
                  'Este aparelho está fingindo ser a maquete "${_casa.codigoMaquete}". '
                  'Agora, em outro celular ou outra aba, conecte o jogo com o mesmo código e jogue as fases.',
                  style: const TextStyle(height: 1.4),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _dispositivo('Portão', _portao, Icons.directions_car, Icons.garage),
                    _dispositivo('Janela', _janela, Icons.air, Icons.window),
                    _dispositivo('Cortina', _cortina, Icons.curtains, Icons.curtains_closed),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Cortina automática: $_auto',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text('Comandos recebidos', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      children: [
                        for (final linha in _historico)
                          Text(
                            linha,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'monospace',
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
