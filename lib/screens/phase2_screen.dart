import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/lumi_reaction.dart';
import '../widgets/phase_progress_bar.dart';
import 'phase2_reward_screen.dart';

class Phase2Screen extends StatefulWidget {
  const Phase2Screen({super.key});

  @override
  State<Phase2Screen> createState() => _Phase2ScreenState();
}

class _Phase2ScreenState extends State<Phase2Screen> {
  // Dispositivos da casa e seus endereços
  static const List<String> _dispositivos = ['Luz da sala', 'Ventilador', 'Janela'];
  static const List<String> _acoes = ['LIGAR', 'DESLIGAR'];

  String? _dispositivo;
  String? _acao;
  bool _ventiladorLigado = false;
  bool _hasError = false;
  String _dicaAtual = '';
  int _tentativasErradas = 0;

  // Dicas progressivas (1º erro = pergunta, 2º = pista, 3º+ = resposta guiada)
  static const List<String> _dicasDispositivo = [
    'A luz da sala acendeu... mas a gente queria vento, não luz. Para quem foi o comando?',
    'Pista: o aparelho que faz vento é o de endereço 2.',
    'Escolha o Ventilador (end. 2) como destino do comando.',
  ];
  static const List<String> _dicasAcao = [
    'O ventilador recebeu o recado, mas o recado foi "fica quieto". Que ação faz ele girar?',
    'Pista: para começar a funcionar, o comando é o contrário de desligar.',
    'Escolha a ação LIGAR.',
  ];

  int _endereco(String dispositivo) => _dispositivos.indexOf(dispositivo) + 1;

  Future<void> _enviarComando() async {
    if (_dispositivo == null || _acao == null) {
      setState(() {
        _hasError = true;
        _dicaAtual = 'Um comando precisa de duas partes: para QUEM (o dispositivo) e O QUÊ (a ação). Escolha as duas!';
      });
      return;
    }

    final dispositivoCerto = _dispositivo == 'Ventilador';
    final acaoCerta = _acao == 'LIGAR';

    if (dispositivoCerto && acaoCerta) {
      setState(() {
        _ventiladorLigado = true;
        _hasError = false;
      });
      await mostrarReacaoLumi(
        context,
        mood: LumiMood.celebrando,
        titulo: 'Sentiu o vento?',
        mensagem: 'Foi você que mandou! Um comando diz para QUEM e O QUÊ fazer, e o ventilador obedeceu.',
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Phase2RewardScreen()),
      );
      return;
    }

    final dicas = dispositivoCerto ? _dicasAcao : _dicasDispositivo;
    final dica = dicas[_tentativasErradas.clamp(0, dicas.length - 1)];
    setState(() {
      _hasError = true;
      _dicaAtual = dica;
      _tentativasErradas++;
    });
    GameState.instance.registrarErro(2);
    await mostrarReacaoLumi(
      context,
      mood: LumiMood.alerta,
      titulo: 'Ops! O comando não funcionou',
      mensagem: dica,
      textoBotao: 'TENTAR DE NOVO',
    );
  }

  Widget _seletor({
    required String titulo,
    required List<String> opcoes,
    required String? selecionado,
    required ValueChanged<String> onSelect,
    String Function(String)? rotulo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final opcao in opcoes)
              ChoiceChip(
                label: Text(rotulo != null ? rotulo(opcao) : opcao),
                selected: selecionado == opcao,
                selectedColor: const Color(0xFFFFCCBC),
                onSelected: _ventiladorLigado ? null : (_) => onSelect(opcao),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final comandoTexto = (_dispositivo == null || _acao == null)
        ? 'ENVIAR → ? | ?'
        : 'ENVIAR → end. ${_endereco(_dispositivo!)} | $_acao';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 2: Comandos & Instruções'),
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
              const PhaseProgressBar(currentStep: 2, totalSteps: 5),
              const SizedBox(height: 12),

              LumiDialogCard(
                mood: _hasError ? LumiMood.pensando : LumiMood.instruindo,
                text: _hasError
                    ? _dicaAtual
                    : 'Tá abafado aqui! Cada aparelho da casa tem um endereço, como uma casa numa rua. Monte o comando: para QUEM e O QUÊ.',
              ),
              const SizedBox(height: 20),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        _ventiladorLigado ? Icons.air : Icons.mode_fan_off,
                        size: 64,
                        color: _ventiladorLigado ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _ventiladorLigado ? 'Ventilador: LIGADO' : 'Ventilador: DESLIGADO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _ventiladorLigado ? Colors.blue : Colors.grey.shade700,
                        ),
                      ),
                      const Divider(height: 28),
                      _seletor(
                        titulo: '1. Para quem? (dispositivo)',
                        opcoes: _dispositivos,
                        selecionado: _dispositivo,
                        rotulo: (d) => '$d (end. ${_endereco(d)})',
                        onSelect: (d) => setState(() => _dispositivo = d),
                      ),
                      const SizedBox(height: 16),
                      _seletor(
                        titulo: '2. O quê? (ação)',
                        opcoes: _acoes,
                        selecionado: _acao,
                        onSelect: (a) => setState(() => _acao = a),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          comandoTexto,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _ventiladorLigado ? null : _enviarComando,
                icon: const Icon(Icons.send),
                label: const Text(
                  'ENVIAR COMANDO',
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
