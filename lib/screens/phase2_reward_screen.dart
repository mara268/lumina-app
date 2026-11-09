import 'package:flutter/material.dart';
import '../story/roteiro.dart';
import 'fase_concluida_screen.dart';
import 'passagem_screen.dart';

class Phase2RewardScreen extends StatelessWidget {
  const Phase2RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FaseConcluidaScreen(
      numeroFase: 2,
      conceito: 'Comandos e atuadores',
      comoResolveu:
          'A casa estava abafada e era preciso deixar o vento entrar. Para isso, você montou um comando em duas escolhas:\n'
          '1. Para QUEM: a Janela, que mora no endereço /janela.\n'
          '2. O QUÊ: a ação ABRIR.\n'
          'O app juntou as duas partes em uma mensagem só e enviou para o endereço da janela. A janela recebeu e abriu.',
      codigo: 'ENVIAR → /janela | ABRIR\n'
          '            ↑        ↑\n'
          '        para quem   o quê\n'
          '        (janela)   (ação)',
      porQueFunciona:
          'Cada parte da casa tem um endereço, como uma casa em uma rua. Quando o comando chega no endereço certo com a ação certa, o atuador (o motor da janela) obedece. É assim que o app conversa com a maquete: pela internet, ele envia a mensagem janela/abrir para o canal da maquete, e ela obedece.',
      noDiaADia:
          'Quando você digita um endereço no navegador, está fazendo a mesma coisa: pedindo uma ação para um endereço. O controle remoto também: cada botão envia um comando, e só o aparelho certo responde.',
      iconeDiaADia: Icons.settings_remote_outlined,
      // texto do botão e próxima passagem vêm do Twine (passagem "Fase 2")
      textoBotao: Roteiro.instancia.linkDepoisDaFase(2)?.texto ?? 'CONTINUAR',
      proximaTela: (context) => PassagemScreen(
        nome: Roteiro.instancia.linkDepoisDaFase(2)?.destino ?? 'Final',
      ),
    );
  }
}