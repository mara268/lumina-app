import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../story/historia.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/lumi_reaction.dart';
import '../widgets/phase_progress_bar.dart';
import 'phase3_reward_screen.dart';

class Phase3Screen extends StatefulWidget {
  const Phase3Screen({super.key});

  @override
  State<Phase3Screen> createState() => _Phase3ScreenState();
}

class _Phase3ScreenState extends State<Phase3Screen> {
  static const List<int> _limites = [20, 40, 80];
  static const List<String> _acoes = ['LIGAR', 'DESLIGAR'];

  double _luminosidade = 80.0;
  int? _limite;
  String? _acaoEntao;
  String? _acaoSenao;
  bool _faseConcluida = false;
  bool _hasError = false;
  String _dicaAtual = '';
  int _tentativasErradas = 0;
  bool _atalhoDecidido = false; // escolha 2 do roteiro

  Future<void> _decidirAtalho(bool aceitou) async {
    GameState.instance.escolherAtalho(aceitou);
    if (aceitou) {
      // a luz fica acesa até de dia: a energia do gerador cai 20
      setState(() => _luminosidade = 100);
      await mostrarReacaoLumi(
        context,
        mood: LumiMood.alerta,
        titulo: 'Sol a pino e a luz acesa...',
        mensagem: Historia.reacaoAceitouAtalho,
        textoBotao: 'FAZER A CASA DECIDIR',
        energia: -20,
      );
    } else {
      await mostrarReacaoLumi(
        context,
        mood: LumiMood.celebrando,
        titulo: 'Boa escolha!',
        mensagem: Historia.reacaoRecusouAtalho,
        textoBotao: 'MONTAR A DECISÃO',
        energia: 0,
      );
    }
    if (!mounted) return;
    setState(() {
      _atalhoDecidido = true;
      _luminosidade = 80;
    });
  }

  Widget _escolhaAtalho() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          onPressed: () => _decidirAtalho(true),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: Color(0xFFE65100), width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('"Vamos deixar ligada direto."', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _decidirAtalho(false),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: Color(0xFFE65100), width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('"Melhor a casa decidir sozinha."', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  bool get _programaCompleto => _limite != null && _acaoEntao != null && _acaoSenao != null;

  /// A lâmpada segue o programa montado pela jogadora (se estiver completo).
  bool get _lampadaLigada {
    if (!_programaCompleto) return false;
    final condicao = _luminosidade < _limite!;
    final acao = condicao ? _acaoEntao : _acaoSenao;
    return acao == 'LIGAR';
  }

  Future<void> _validarPrograma() async {
    if (!_programaCompleto) {
      setState(() {
        _hasError = true;
        _dicaAtual = 'Falta completar o bloco: escolha o limite, o que fazer no ENTÃO e o que fazer no SENÃO.';
      });
      return;
    }

    String? erro;
    if (_acaoEntao == _acaoSenao) {
      erro = 'Do jeito que está, a luz faz a mesma coisa de dia e de noite. Aí a decisão não serve pra nada!';
    } else if (_acaoEntao == 'DESLIGAR') {
      erro = 'Agora a luz acende de dia e apaga de noite. A casa ficou do avesso!';
    } else if (_limite! > 40) {
      erro = 'Com $_limite, a luz acenderia até no meio da tarde e gastaria energia à toa. Escolha um limite que só aconteça quando escurece de verdade.';
    }

    if (erro == null) {
      setState(() {
        _faseConcluida = true;
        _hasError = false;
        _luminosidade = 10; // mostra a noite chegando e a luz acendendo
      });
      await mostrarReacaoLumi(
        context,
        mood: LumiMood.celebrando,
        titulo: 'A varanda acendeu sozinha!',
        mensagem: 'A casa agora pensa antes de agir: SE está escuro, ENTÃO liga; SENÃO, desliga. Isso é uma decisão!',
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Phase3RewardScreen()),
      );
      return;
    }

    // a partir do 2º erro, a Lumi dá a pista concreta
    final dica = _tentativasErradas >= 1
        ? '$erro\n\nPista: SE a luz estiver baixa (escuro) ENTÃO LIGAR; SENÃO DESLIGAR.'
        : erro;
    setState(() {
      _hasError = true;
      _dicaAtual = dica;
      _tentativasErradas++;
    });
    GameState.instance.registrarErro(3);
    await mostrarReacaoLumi(
      context,
      mood: LumiMood.alerta,
      titulo: 'Hmm, a casa se confundiu',
      mensagem: dica,
      textoBotao: 'TENTAR DE NOVO',
    );
  }

  Widget _chips<T>({
    required List<T> opcoes,
    required T? selecionado,
    required ValueChanged<T> onSelect,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final opcao in opcoes)
          ChoiceChip(
            label: Text('$opcao'),
            selected: selecionado == opcao,
            selectedColor: const Color(0xFFFFE082),
            onSelected: _faseConcluida ? null : (_) => onSelect(opcao),
          ),
      ],
    );
  }

  Widget _linhaBloco(String palavra, Widget conteudo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              palavra,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF6A1B9A),
                fontSize: 15,
              ),
            ),
          ),
          Expanded(child: conteudo),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 3: Condições (IF/ELSE)'),
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
              const PhaseProgressBar(currentStep: 3, totalSteps: 5),
              const SizedBox(height: 12),

              LumiDialogCard(
                mood: !_atalhoDecidido || _hasError ? LumiMood.pensando : LumiMood.instruindo,
                text: !_atalhoDecidido
                    ? 'A noite está chegando e o quintal vai ficar um breu. ${Historia.propostaAtalho}'
                    : _hasError
                    ? _dicaAtual
                    : 'A noite está chegando e o quintal vai ficar um breu. O sensor mede a luz de 0 (escuro) a 100 (sol forte). Monte a decisão para a luz da varanda!',
              ),
              const SizedBox(height: 20),

              if (!_atalhoDecidido) _escolhaAtalho(),
              if (_atalhoDecidido) ...[
              // Bloco de decisão
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _linhaBloco(
                        'SE',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('luminosidade for menor que'),
                            const SizedBox(height: 6),
                            _chips<int>(
                              opcoes: _limites,
                              selecionado: _limite,
                              onSelect: (v) => setState(() => _limite = v),
                            ),
                          ],
                        ),
                      ),
                      _linhaBloco(
                        'ENTÃO',
                        _chips<String>(
                          opcoes: _acoes,
                          selecionado: _acaoEntao,
                          onSelect: (v) => setState(() => _acaoEntao = v),
                        ),
                      ),
                      _linhaBloco(
                        'SENÃO',
                        _chips<String>(
                          opcoes: _acoes,
                          selecionado: _acaoSenao,
                          onSelect: (v) => setState(() => _acaoSenao = v),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Simulador: a lâmpada segue o programa da jogadora
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        _lampadaLigada ? Icons.lightbulb : Icons.lightbulb_outline,
                        size: 64,
                        color: _lampadaLigada ? Colors.amber : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sensor de luz: ${_luminosidade.toInt()} ${_luminosidade < 30 ? "(noite)" : _luminosidade < 60 ? "(entardecer)" : "(dia)"}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: _luminosidade,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        activeColor: Colors.amber,
                        label: '${_luminosidade.toInt()}',
                        onChanged: _faseConcluida
                            ? null
                            : (value) => setState(() => _luminosidade = value),
                      ),
                      Text(
                        _programaCompleto
                            ? 'Arraste do dia para a noite e veja o seu programa funcionando.'
                            : 'Complete o bloco acima para testar no simulador.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _faseConcluida ? null : _validarPrograma,
                icon: const Icon(Icons.memory),
                label: const Text(
                  'VALIDAR DECISÃO',
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
            ],
          ),
        ),
      ),
    );
  }
}
