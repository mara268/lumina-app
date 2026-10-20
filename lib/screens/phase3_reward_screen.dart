import 'package:flutter/material.dart';
import 'fase_concluida_screen.dart';
import 'phase4_screen.dart';

class Phase3RewardScreen extends StatelessWidget {
  const Phase3RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaseConcluidaScreen(
      numeroFase: 3,
      conceito: 'Condição (SE / SENÃO)',
      comoResolveu:
          'Você ensinou a casa a decidir sozinha: ela olha o sensor de luz e escolhe entre ligar ou desligar a varanda.',
      codigo: 'SE luminosidade < 40 ENTÃO\n'
          '    LIGAR luz da varanda\n'
          'SENÃO\n'
          '    DESLIGAR luz da varanda',
      porQueFunciona:
          'A condição é uma pergunta de sim ou não. Se a resposta for "sim" (está escuro), a casa faz o ENTÃO; se for "não", faz o SENÃO. Assim a luz só gasta energia quando é preciso.',
      noDiaADia:
          'Os postes de rua funcionam assim: um sensor mede a luz e, quando escurece, eles acendem sozinhos.',
      iconeDiaADia: Icons.light_outlined,
      textoBotao: 'AVANÇAR PARA A FASE 4',
      proximaTela: (context) => const Phase4Screen(),
    );
  }
}
