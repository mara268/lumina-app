import 'package:flutter/material.dart';
import 'fase_concluida_screen.dart';
import 'phase3_screen.dart';

class Phase2RewardScreen extends StatelessWidget {
  const Phase2RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaseConcluidaScreen(
      numeroFase: 2,
      conceito: 'Comandos e atuadores',
      comoResolveu:
          'Você montou um comando com as duas partes que ele precisa: para QUEM (o ventilador, endereço 2) e O QUÊ (ligar).',
      codigo: 'ENVIAR → end. 2 | LIGAR\n'
          '         ↑          ↑\n'
          '     para quem    o quê',
      porQueFunciona:
          'Cada aparelho da casa tem um endereço, como uma casa em uma rua. Quando o comando chega no endereço certo com a ação certa, o atuador (o motor do ventilador) obedece. É assim que a maquete conversa com o app pelo protocolo Modbus.',
      noDiaADia:
          'O controle remoto faz isso: cada botão envia um comando com uma ação, e só o aparelho certo responde.',
      iconeDiaADia: Icons.settings_remote_outlined,
      textoBotao: 'AVANÇAR PARA A FASE 3',
      proximaTela: (context) => const Phase3Screen(),
    );
  }
}
