import 'package:flutter/material.dart';
import '../story/roteiro.dart';
import 'fase_concluida_screen.dart';
import 'passagem_screen.dart';

class Phase3RewardScreen extends StatelessWidget {
  const Phase3RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaseConcluidaScreen(
      numeroFase: 3,
      conceito: 'Condição (SE / SENÃO)',
      comoResolveu:
          'A noite estava chegando e a luz da varanda precisava acender sozinha, mas só quando escurecesse. Para isso, você montou uma decisão em três partes:\n'
          '1. SE: a pergunta. O sensor mede a luz de 0 (escuro) a 100 (sol forte), e você escolheu um limite baixo, que só acontece de noite (por exemplo, 40).\n'
          '2. ENTÃO: o que fazer quando a resposta é "sim, está escuro": LIGAR a luz.\n'
          '3. SENÃO: o que fazer quando a resposta é "não, ainda está claro": DESLIGAR a luz.\n'
          'Quando a noite chegou, a casa fez a pergunta sozinha, viu que estava escuro e acendeu a varanda.',
      codigo: 'SE luminosidade < 40 ENTÃO\n'
          '    LIGAR luz da varanda     ← escuro\n'
          'SENÃO\n'
          '    DESLIGAR luz da varanda  ← claro',
      porQueFunciona:
          'A condição é uma pergunta de sim ou não. Se a resposta for "sim" (está escuro), a casa faz o ENTÃO; se for "não", faz o SENÃO. Assim a luz só gasta energia quando é preciso.',
      noDiaADia:
          'Os postes de rua funcionam assim: um sensor mede a luz e, quando escurece, eles acendem sozinhos.',
      iconeDiaADia: Icons.light_outlined,
      // texto do botão e próxima passagem vêm do Twine (passagem "Fase 3")
      textoBotao: Roteiro.instancia.linkDepoisDaFase(3)?.texto ?? 'CONTINUAR',
      proximaTela: (context) => PassagemScreen(
        nome: Roteiro.instancia.linkDepoisDaFase(3)?.destino ?? 'Final',
      ),
    );
  }
}