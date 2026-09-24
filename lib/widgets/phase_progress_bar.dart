import 'package:flutter/material.dart';

class PhaseProgressBar extends StatelessWidget {
  final int currentStep; // de 1 a 5
  final int totalSteps;

  const PhaseProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

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
        ],
      ),
    );
  }
}