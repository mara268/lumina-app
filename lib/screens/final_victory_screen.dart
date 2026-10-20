import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../story/historia.dart';
import '../widgets/card_mulher_widget.dart';
import '../widgets/lumi_avatar.dart';
import '../widgets/phase_progress_bar.dart';

/// Tela final: a jogadora vira guardiã da casa, vê a galeria com os 5 cards
/// e responde à pergunta aberta da pesquisa.
class FinalVictoryScreen extends StatefulWidget {
  const FinalVictoryScreen({super.key});

  @override
  State<FinalVictoryScreen> createState() => _FinalVictoryScreenState();
}

class _FinalVictoryScreenState extends State<FinalVictoryScreen> {
  final TextEditingController _resposta = TextEditingController();
  bool _respostaSalva = false;

  @override
  void dispose() {
    _resposta.dispose();
    super.dispose();
  }

  void _salvarResposta() {
    if (_resposta.text.trim().isEmpty) return;
    GameState.instance.respostaAberta = _resposta.text.trim();
    FocusScope.of(context).unfocus();
    setState(() => _respostaSalva = true);
  }

  @override
  Widget build(BuildContext context) {
    final estado = GameState.instance;
    final cards = [
      for (int f = 1; f <= 4; f++) Historia.cards[f]!,
      Historia.cardDaJogadora(estado),
    ];
    final corEnergia = PhaseProgressBar.corDaEnergia(estado.energia);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: LumiAvatar(mood: LumiMood.celebrando, height: 170)),
              const SizedBox(height: 12),
              const Text(
                'GUARDIÃ DA CASA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
              Text(
                estado.nomeOuPadrao,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Agora a casa é sua para cuidar e para melhorar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: corEnergia.withAlpha(40),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: corEnergia),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 18, color: corEnergia),
                      Text(
                        'Energia final do gerador: ${estado.energia}%',
                        style: TextStyle(color: corEnergia, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Sua galeria: Conexões Invisíveis',
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
                children: [
                  for (final c in cards) CardMulherWidget(card: c, compacto: true),
                ],
              ),
              const SizedBox(height: 28),

              // Pergunta aberta (dado qualitativo para a pesquisa)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'E agora, guardiã: o que você automatizaria na sua casa?',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    if (_respostaSalva)
                      Text(
                        '"${estado.respostaAberta}"\n\nResposta guardada. Obrigada!',
                        style: const TextStyle(color: Color(0xFF7CF5C6), fontSize: 14.5, height: 1.5),
                      )
                    else ...[
                      TextField(
                        controller: _resposta,
                        maxLines: 3,
                        maxLength: 280,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ex.: uma luz que acende quando eu chego...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          counterStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white.withAlpha(12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _resposta.text.trim().isEmpty ? null : _salvarResposta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00838F),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('ENVIAR RESPOSTA', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: () {
                  GameState.instance.reiniciar();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.replay),
                label: const Text('JOGAR DE NOVO', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Lúmina: Conexões Invisíveis · PIBIC/UDF',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
