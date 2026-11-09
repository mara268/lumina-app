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
          '  sensor → placa → fechar portão\n'
          '  ENVIAR → /janela | FECHAR\n'
          '  SE luz < 40 ENTÃO fechar cortina SENÃO abrir\n'
          '  QUANDO chuva FAÇA fechar janela',
      porQueFunciona:
          'Programas de verdade são feitos de partes pequenas que se encaixam. Cada bloco cuida de uma coisa, e juntos eles fazem o sistema inteiro funcionar. Reaproveitar o que já foi feito é o que as programadoras fazem todos os dias.',
      noDiaADia:
          'Uma casa inteligente de verdade faz isso: portão, janelas e cortinas trabalhando juntos, cada um reagindo ao seu sensor ou comando.',
      iconeDiaADia: Icons.home_work_outlined,
      // texto do botão e próxima passagem vêm do Twine (passagem "Fase 5")
      textoBotao: Roteiro.instancia.linkDepoisDaFase(5)?.texto ?? 'CONTINUAR',
      proximaTela: (context) => PassagemScreen(
        nome: Roteiro.instancia.linkDepoisDaFase(5)?.destino ?? 'Final',
      ),
    );
  }
}
