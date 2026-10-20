import 'package:flutter/material.dart';
import '../story/roteiro.dart';
import 'fase_concluida_screen.dart';
import 'passagem_screen.dart';

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
          'Um evento é algo que acontece de surpresa, como a chuva começar. A casa não precisa ficar perguntando a cada minuto “está chovendo?”: o sensor avisa no exato momento em que sente a água, e a janela fecha na hora. Por isso a reação é rápida e ninguém precisa ficar de olho.',
      noDiaADia:
          'A notificação do celular é um evento: quando chega uma mensagem, o celular vibra sozinho, sem você ficar abrindo o app para conferir.',
      iconeDiaADia: Icons.notifications_active_outlined,
      // texto do botão e próxima passagem vêm do Twine (passagem "Fase 4")
      textoBotao: Roteiro.instancia.linkDepoisDaFase(4)?.texto ?? 'CONTINUAR',
      proximaTela: (context) => PassagemScreen(
        nome: Roteiro.instancia.linkDepoisDaFase(4)?.destino ?? 'Final',
      ),
    );
  }
}
