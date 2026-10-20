import 'package:flutter/material.dart';
import '../story/roteiro.dart';
import 'fase_concluida_screen.dart';
import 'passagem_screen.dart';

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
          'Sabe a porta automática do mercado? Ela segue a mesma ordem: primeiro o sensor percebe que você chegou, depois o sistema decide que é hora de abrir e, por último, o motor abre a porta. Se a ordem fosse outra, ela abriria antes de alguém chegar!',
      iconeDiaADia: Icons.storefront_outlined,
      // texto do botão e próxima passagem vêm do Twine (passagem "Fase 1")
      textoBotao: Roteiro.instancia.linkDepoisDaFase(1)?.texto ?? 'CONTINUAR',
      proximaTela: (context) => PassagemScreen(
        nome: Roteiro.instancia.linkDepoisDaFase(1)?.destino ?? 'Final',
      ),
    );
  }
}
