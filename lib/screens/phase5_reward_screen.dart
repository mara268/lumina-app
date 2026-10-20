import 'package:flutter/material.dart';
import '../story/roteiro.dart';
import 'fase_concluida_screen.dart';
import 'passagem_screen.dart';

class Phase5RewardScreen extends StatelessWidget {
  const Phase5RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaseConcluidaScreen(
      numeroFase: 5,
      conceito: 'Integração de sistemas',
      comoResolveu:
          'Você juntou os blocos de todas as fases numa única rotina e deixou de fora as pegadinhas. A casa inteira passou a funcionar com o seu programa.',
      codigo: 'ROTINA DA NOITE\n'
          '  ENVIAR → ventilador | LIGAR\n'
          '  SE luz < 40 ENTÃO ligar varanda SENÃO desligar\n'
          '  QUANDO presença FAÇA acender corredor\n'
          '  QUANDO chuva FAÇA fechar janelas',
      porQueFunciona:
          'Programas de verdade são feitos de partes pequenas que se encaixam. Cada bloco cuida de uma coisa, e juntos eles fazem o sistema inteiro funcionar. Reaproveitar o que já foi feito é o que as programadoras fazem todos os dias.',
      noDiaADia:
          'Uma casa inteligente de verdade faz isso: luzes, ventilação e janelas trabalhando juntas, cada uma reagindo ao seu sensor.',
      iconeDiaADia: Icons.home_work_outlined,
      // texto do botão e próxima passagem vêm do Twine (passagem "Fase 5")
      textoBotao: Roteiro.instancia.linkDepoisDaFase(5)?.texto ?? 'CONTINUAR',
      proximaTela: (context) => PassagemScreen(
        nome: Roteiro.instancia.linkDepoisDaFase(5)?.destino ?? 'Final',
      ),
    );
  }
}
