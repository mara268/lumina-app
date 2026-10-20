import 'package:flutter/material.dart';
import 'fase_concluida_screen.dart';
import 'phase2_screen.dart';

class Phase1RewardScreen extends StatelessWidget {
  const Phase1RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaseConcluidaScreen(
      numeroFase: 1,
      conceito: 'Sequência lógica',
      comoResolveu:
          'Você colocou os passos na ordem em que a casa precisa: primeiro perceber, depois pensar e só então agir.',
      codigo: '1. Ler sensor de presença      (entrada)\n'
          '2. Processar decisão na placa  (processamento)\n'
          '3. Ligar lâmpada do corredor   (saída)',
      porQueFunciona:
          'O computador executa exatamente o que mandamos, na ordem em que mandamos. Se a lâmpada viesse primeiro, ela acenderia sem saber se tinha alguém ali.',
      noDiaADia:
          'A porta automática do mercado faz a mesma sequência: o sensor percebe você chegando, a placa decide e o motor abre a porta.',
      iconeDiaADia: Icons.storefront_outlined,
      textoBotao: 'AVANÇAR PARA A FASE 2',
      proximaTela: (context) => const Phase2Screen(),
    );
  }
}
