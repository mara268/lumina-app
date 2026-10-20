import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/lumi_reaction.dart';
import '../widgets/phase_progress_bar.dart';
import 'phase4_reward_screen.dart';

class Phase4Screen extends StatefulWidget {
  const Phase4Screen({super.key});

  @override
  State<Phase4Screen> createState() => _Phase4ScreenState();
}

class _Phase4ScreenState extends State<Phase4Screen> {
  static const List<String> _janelas = ['Escritório', 'Estufa'];
  static const List<String> _eventos = [
    'sensor de chuva detectar água',
    'sensor de luz ficar abaixo de 40',
    'alguém passar no corredor',
  ];
  static const List<String> _acoes = [
    'fechar a janela',
    'abrir a janela',
    'ligar o ventilador',
  ];

  String? _janela;
  String? _evento;
  String? _acao;
  bool _estaChovendo = false;
  bool _janelaFechada = false;
  bool _hasError = false;
  String _dicaAtual = '';
  int _tentativasErradas = 0;

  bool get _blocoCompleto => _janela != null && _evento != null && _acao != null;

  Future<void> _simularChuva() async {
    if (!_blocoCompleto) {
      setState(() {
        _hasError = true;
        _dicaAtual = 'Antes da chuva chegar, escolha qual janela proteger e complete o bloco QUANDO / FAÇA.';
      });
      return;
    }

    setState(() => _estaChovendo = true);
    final eventoCerto = _evento == _eventos[0];
    final acaoCerta = _acao == _acoes[0];

    if (eventoCerto && acaoCerta) {
      setState(() {
        _janelaFechada = true;
        _hasError = false;
      });
      final memoria = _janela == 'Escritório'
          ? 'O diário e os cadernos da vó Helena estão secos e salvos.'
          : 'As mudas de ipê e pequi da vó Helena estão protegidas.';
      await mostrarReacaoLumi(
        context,
        mood: LumiMood.celebrando,
        titulo: 'A casa ouviu a chuva!',
        mensagem: 'Você nem precisou olhar: o evento disparou a ação sozinho. $memoria',
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Phase4RewardScreen()),
      );
      return;
    }

    String erro;
    if (!eventoCerto) {
      erro = 'A casa reagiu, mas ao evento errado. O que a chuva tem a ver com "$_evento"?';
    } else if (_acao == _acoes[1]) {
      erro = 'Abrir a janela na chuva?! O cômodo ia virar piscina!';
    } else {
      erro = 'O ventilador ligou... mas a chuva continua entrando pela janela!';
    }
    final dica = _tentativasErradas >= 1
        ? '$erro\n\nPista: QUANDO o sensor de chuva detectar água, FAÇA fechar a janela.'
        : erro;

    setState(() {
      _hasError = true;
      _dicaAtual = dica;
      _tentativasErradas++;
    });
    await mostrarReacaoLumi(
      context,
      mood: LumiMood.alerta,
      titulo: 'Chuva entrando!',
      mensagem: dica,
      textoBotao: 'TENTAR DE NOVO',
    );
    if (!mounted) return;
    setState(() => _estaChovendo = false);
  }

  Widget _chips({
    required List<String> opcoes,
    required String? selecionado,
    required ValueChanged<String> onSelect,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final opcao in opcoes)
          ChoiceChip(
            label: Text(opcao),
            selected: selecionado == opcao,
            selectedColor: const Color(0xFFB3E5FC),
            onSelected: _janelaFechada ? null : (_) => onSelect(opcao),
          ),
      ],
    );
  }

  Widget _titulo(String texto, {Color? cor}) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(
          texto,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: cor ?? const Color(0xFF2D3142),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 4: Eventos em Tempo Real'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PhaseProgressBar(currentStep: 4, totalSteps: 5),
              const SizedBox(height: 12),

              LumiDialogCard(
                mood: _hasError ? LumiMood.pensando : LumiMood.instruindo,
                text: _hasError
                    ? _dicaAtual
                    : 'A tempestade está voltando e duas janelas estão abertas! Um EVENTO acontece de surpresa e dispara uma ação. Programe a casa para reagir sozinha.',
              ),
              const SizedBox(height: 20),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _titulo('Qual janela proteger primeiro?'),
                      _chips(
                        opcoes: _janelas,
                        selecionado: _janela,
                        onSelect: (v) => setState(() => _janela = v),
                      ),
                      const Divider(height: 28),
                      _titulo('QUANDO', cor: const Color(0xFF0277BD)),
                      _chips(
                        opcoes: _eventos,
                        selecionado: _evento,
                        onSelect: (v) => setState(() => _evento = v),
                      ),
                      const SizedBox(height: 12),
                      _titulo('FAÇA', cor: const Color(0xFF0277BD)),
                      _chips(
                        opcoes: _acoes,
                        selecionado: _acao,
                        onSelect: (v) => setState(() => _acao = v),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(
                            _estaChovendo ? Icons.thunderstorm : Icons.cloud_outlined,
                            size: 48,
                            color: _estaChovendo ? Colors.blue : Colors.blueGrey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _estaChovendo ? 'Chovendo!' : 'Nublado',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            _janelaFechada ? Icons.window : Icons.grid_view,
                            size: 48,
                            color: _janelaFechada ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Janela ${_janela == null ? '' : 'do(a) $_janela'}: ${_janelaFechada ? 'fechada' : 'aberta'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _janelaFechada ? null : _simularChuva,
                icon: const Icon(Icons.water_drop),
                label: const Text(
                  'SIMULAR CHUVA',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
