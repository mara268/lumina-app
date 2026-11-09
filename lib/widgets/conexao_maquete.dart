import 'package:flutter/material.dart';

import '../screens/simulador_maquete_screen.dart';
import '../services/casa_service.dart';

/// Botão da tela inicial que mostra se a maquete está conectada
/// e abre a janela de conexão.
class BotaoMaquete extends StatelessWidget {
  const BotaoMaquete({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CasaService.instance,
      builder: (context, _) {
        final conectada = CasaService.instance.conectada;
        final cor = conectada ? const Color(0xFF7CF5C6) : Colors.white60;
        return TextButton.icon(
          onPressed: () => mostrarConexaoMaquete(context),
          style: TextButton.styleFrom(
            foregroundColor: cor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(color: cor.withAlpha(120)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          icon: Icon(conectada ? Icons.home_work : Icons.home_work_outlined, size: 18),
          label: Text(
            conectada ? 'Maquete conectada' : 'Conectar maquete',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}

/// Linha discreta (usada no topo das fases) que mostra o que a maquete está fazendo.
class StatusMaquete extends StatelessWidget {
  const StatusMaquete({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CasaService.instance,
      builder: (context, _) {
        final casa = CasaService.instance;
        if (!casa.conectada) return const SizedBox.shrink();
        final desligada = casa.modo == ModoConexao.internet && casa.maqueteOnline == false;
        final String texto;
        if (casa.enviando != null) {
          texto = 'Maquete: ${casa.enviando!.descricao}...';
        } else if (desligada) {
          texto = 'Conectado, mas a maquete está desligada';
        } else {
          texto = 'Maquete conectada';
        }
        final cor = desligada ? const Color(0xFFE65100) : const Color(0xFF00897B);
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(
                casa.enviando == null ? Icons.home_work : Icons.sync,
                size: 16,
                color: cor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  texto,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Janela para conectar o app à maquete.
Future<void> mostrarConexaoMaquete(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _DialogoMaquete(),
  );
}

class _DialogoMaquete extends StatefulWidget {
  const _DialogoMaquete();

  @override
  State<_DialogoMaquete> createState() => _DialogoMaqueteState();
}

class _DialogoMaqueteState extends State<_DialogoMaquete> {
  final _casa = CasaService.instance;

  // internet (MQTT)
  late final _codigo = TextEditingController(text: _casa.codigoMaquete);
  late final _servidor = TextEditingController(text: _casa.servidor);
  late final _usuarioMqtt = TextEditingController(text: _casa.usuarioMqtt);
  late final _senhaMqtt = TextEditingController(text: _casa.senhaMqtt);

  // Wi-Fi local
  late final _ip = TextEditingController(text: _casa.ip);
  late final _usuario = TextEditingController(text: _casa.usuario);
  late final _senha = TextEditingController(text: _casa.senha);

  bool _testando = false;
  bool _avancado = false;

  @override
  void dispose() {
    for (final c in [_codigo, _servidor, _usuarioMqtt, _senhaMqtt, _ip, _usuario, _senha]) {
      c.dispose();
    }
    super.dispose();
  }

  void _guardarCampos() {
    _casa
      ..codigoMaquete = _codigo.text.trim()
      ..servidor = _servidor.text.trim()
      ..usuarioMqtt = _usuarioMqtt.text.trim()
      ..senhaMqtt = _senhaMqtt.text
      ..ip = _ip.text.trim()
      ..usuario = _usuario.text.trim()
      ..senha = _senha.text;
  }

  Future<void> _conectar() async {
    _guardarCampos();
    setState(() => _testando = true);
    await _casa.testar();
    if (mounted) setState(() => _testando = false);
  }

  void _abrirSimulador() {
    _guardarCampos();
    final navegador = Navigator.of(context);
    navegador.pop();
    navegador.push(
      MaterialPageRoute(builder: (context) => const SimuladorMaqueteScreen()),
    );
  }

  Widget _campo(TextEditingController controller, String rotulo, {bool senha = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: senha,
        decoration: InputDecoration(
          labelText: rotulo,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _escolhaModo() {
    return SegmentedButton<ModoConexao>(
      segments: const [
        ButtonSegment(value: ModoConexao.internet, icon: Icon(Icons.cloud_outlined), label: Text('Internet')),
        ButtonSegment(value: ModoConexao.wifiLocal, icon: Icon(Icons.wifi), label: Text('Wi-Fi local')),
      ],
      selected: {_casa.modo},
      onSelectionChanged: _casa.conectada
          ? null
          : (escolha) => setState(() {
                _casa.modo = escolha.first;
                _casa.ultimoErro = null;
              }),
    );
  }

  List<Widget> _camposInternet() {
    return [
      const Text(
        'O celular e a maquete precisam estar com internet. '
        'Funciona em qualquer celular, inclusive iPhone.',
        style: TextStyle(height: 1.4),
      ),
      const SizedBox(height: 14),
      _campo(_codigo, 'Código da maquete'),
      TextButton.icon(
        onPressed: () => setState(() => _avancado = !_avancado),
        icon: Icon(_avancado ? Icons.expand_less : Icons.expand_more),
        label: const Text('Servidor MQTT'),
      ),
      if (_avancado) ...[
        _campo(_servidor, 'Servidor (broker)'),
        _campo(_usuarioMqtt, 'Usuário (deixe vazio no servidor de teste)'),
        _campo(_senhaMqtt, 'Senha', senha: true),
      ],
    ];
  }

  List<Widget> _camposWifiLocal() {
    if (!_casa.suportado) {
      return const [
        Text(
          'Neste endereço, o Wi-Fi local não funciona. Use "Internet" '
          'ou abra o jogo pela ponte do notebook (um endereço que começa com http://).',
          style: TextStyle(height: 1.4),
        ),
      ];
    }
    return [
      Text(
        _casa.usaPonte
            ? '1. A ponte precisa estar rodando no notebook.\n'
                '2. O celular e o notebook precisam estar no Wi-Fi da maquete.\n'
                '3. Confira o usuário e a senha e toque em CONECTAR.'
            : '1. Conecte o celular ao Wi-Fi da maquete.\n'
                '2. Confira o endereço e a senha abaixo.\n'
                '3. Toque em CONECTAR.',
        style: const TextStyle(height: 1.5),
      ),
      const SizedBox(height: 14),
      // pela ponte, quem sabe o endereço da maquete é o notebook
      if (!_casa.usaPonte) _campo(_ip, 'Endereço da maquete (IP)'),
      _campo(_usuario, 'Usuário'),
      _campo(_senha, 'Senha', senha: true),
    ];
  }

  Widget _resultado() {
    if (_casa.conectada) {
      final desligada = _casa.modo == ModoConexao.internet && _casa.maqueteOnline != true;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(desligada ? Icons.info_outline : Icons.check_circle,
              color: desligada ? const Color(0xFFE65100) : const Color(0xFF43A047)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              desligada
                  ? 'Conectado ao servidor, mas a maquete ainda não respondeu. Ela está ligada e com internet? '
                      '(Os comandos serão enviados mesmo assim.)'
                  : 'Maquete conectada! Ela vai se mexer quando você acertar as fases.',
            ),
          ),
        ],
      );
    }
    if (_casa.ultimoErro != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE53935)),
          const SizedBox(width: 8),
          Expanded(child: Text(_casa.ultimoErro!)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _casa,
      builder: (context, _) {
        final internet = _casa.modo == ModoConexao.internet;
        return AlertDialog(
          title: const Text('Conectar à maquete'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _escolhaModo(),
                const SizedBox(height: 14),
                ...(internet ? _camposInternet() : _camposWifiLocal()),
                const SizedBox(height: 6),
                _resultado(),
                if (internet && !_casa.conectada) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _abrirSimulador,
                    icon: const Icon(Icons.science_outlined),
                    label: const Text('ABRIR SIMULADOR DA MAQUETE'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sem a maquete? Abra o simulador em outro celular ou outra aba do navegador: '
                    'ele finge ser a maquete e mostra os comandos chegando.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            if (_casa.conectada)
              TextButton(
                onPressed: _casa.desconectar,
                child: const Text('DESCONECTAR'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('FECHAR'),
            ),
            if (_casa.suportado && !_casa.conectada)
              ElevatedButton(
                onPressed: _testando ? null : _conectar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                ),
                child: _testando
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('CONECTAR'),
              ),
          ],
        );
      },
    );
  }
}
