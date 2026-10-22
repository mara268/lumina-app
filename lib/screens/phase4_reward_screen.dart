import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../story/roteiro.dart';
import 'fase_concluida_screen.dart';
import 'passagem_screen.dart';

class Phase4RewardScreen extends StatelessWidget {
  const Phase4RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // a janela que a jogadora escolheu proteger na fase
    final janela = GameState.instance.janela == JanelaProtegida.estufa ? 'da estufa' : 'do escritório';

    return FaseConcluidaScreen(
      numeroFase: 4,
      conceito: 'Eventos',
      comoResolveu:
          'A tempestade estava voltando e a janela $janela estava aberta. Ninguém sabia a hora exata em que a chuva ia começar, então a casa precisava reagir sozinha. Para isso, você montou um bloco em duas partes:\n'
          '1. QUANDO: o evento, ou seja, o que dispara a ação. Você escolheu "o sensor de chuva detectar água".\n'
          '2. FAÇA: a ação que acontece na mesma hora. Você escolheu "fechar a janela".\n'
          'Quando a chuva caiu, o sensor sentiu a primeira gota, avisou a casa, e a janela fechou sozinha, sem ninguém apertar botão.',
      codigo: 'QUANDO sensor de chuva detectar água\n'
          '    FAÇA fechar a janela\n'
          '\n'
          '  QUANDO = o que acontece\n'
          '  FAÇA   = como a casa reage',
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
