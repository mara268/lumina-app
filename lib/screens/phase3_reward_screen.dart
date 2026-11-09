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
          'A noite estava chegando e a cortina do quarto precisava fechar sozinha, mas só quando escurecesse. Para isso, você montou uma decisão em três partes:\n'
          '1. SE: a pergunta. O sensor mede a luz de 0 (escuro) a 100 (sol forte), e você escolheu um limite baixo, que só acontece de noite (por exemplo, 40).\n'
          '2. ENTÃO: o que fazer quando a resposta é "sim, está escuro": FECHAR a cortina.\n'
          '3. SENÃO: o que fazer quando a resposta é "não, ainda está claro": ABRIR a cortina.\n'
          'Quando a noite chegou, a casa fez a pergunta sozinha, viu que estava escuro e fechou a cortina.',
      codigo: 'SE luminosidade < 40 ENTÃO\n'
          '    FECHAR cortina   ← escuro\n'
          'SENÃO\n'
          '    ABRIR cortina    ← claro',
      porQueFunciona:
          'A condição é uma pergunta de sim ou não. Se a resposta for "sim" (está escuro), a casa faz o ENTÃO; se for "não", faz o SENÃO. Assim a cortina fecha à noite para proteger a casa e abre de dia para a luz do sol entrar, sem gastar energia à toa.',
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