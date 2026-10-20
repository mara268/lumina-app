import 'package:flutter/material.dart';

import '../models/game_state.dart';

/// Progresso da missão + energia do gerador (que muda com acertos, erros
/// e escolhas). A energia se atualiza sozinha quando o GameState muda.
class PhaseProgressBar extends StatelessWidget {
  final int currentStep; // de 1 a 5
  final int totalSteps;
  final bool mostrarEnergia;

  const PhaseProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    this.mostrarEnergia = true,
  });

  static Color corDaEnergia(int energia) {
    if (energia < 20) return const Color(0xFFE53935);
    if (energia < 40) return const Color(0xFFFFA000);
    return const Color(0xFF43A047);
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso da Missão',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                'Fase $currentStep de $totalSteps',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFFFE0B2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE65100)),
            ),
          ),
          if (mostrarEnergia) ...[
            const SizedBox(height: 10),
            ListenableBuilder(
              listenable: GameState.instance,
              builder: (context, _) {
                final energia = GameState.instance.energia;
                final cor = corDaEnergia(energia);
                return Row(
                  children: [
                    Icon(Icons.bolt, size: 18, color: cor),
                    const SizedBox(width: 4),
                    Text(
                      'Gerador',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(end: energia / 100),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          builder: (context, valor, _) => LinearProgressIndicator(
                            value: valor,
                            minHeight: 6,
                            backgroundColor: cor.withAlpha(40),
                            valueColor: AlwaysStoppedAnimation<Color>(cor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$energia%',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cor),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
