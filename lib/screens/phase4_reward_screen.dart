import 'package:flutter/material.dart';
import 'fase_concluida_screen.dart';
import 'phase5_screen.dart';

class Phase4RewardScreen extends StatelessWidget {
  const Phase4RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaseConcluidaScreen(
      numeroFase: 4,
      conceito: 'Eventos',
      comoResolveu:
          'Você programou a casa para reagir sozinha: quando o sensor de chuva detecta água, a janela fecha na hora.',
      codigo: 'QUANDO sensor de chuva detectar água\n'
          '    FAÇA fechar a janela',
      porQueFunciona:
          'Na fase anterior, a casa conferia a luz o tempo todo. Um evento é diferente: ele acontece de surpresa e dispara a ação na mesma hora, sem ninguém precisar ficar olhando.',
      noDiaADia:
          'Um evento é algo que acontece de surpresa, como a chuva começar. A casa não precisa ficar perguntando a cada minuto “está chovendo?”: o sensor avisa no exato momento em que sente a água, e a janela fecha na hora. Por isso a reação é rápida e ninguém precisa ficar de olho.',
      iconeDiaADia: Icons.notifications_active_outlined,
      textoBotao: 'AVANÇAR PARA A ÚLTIMA FASE',
      proximaTela: (context) => const Phase5Screen(),
    );
  }
}
