import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../story/historia.dart';
import '../widgets/card_mulher_widget.dart';

/// Card "Conexões Invisíveis" desbloqueado depois de cada memória.
/// Cards 1 a 4: mulheres da computação. Card 5: a própria jogadora.
class CardScreen extends StatelessWidget {
  final int numero;
  final String textoBotao;
  final VoidCallback aoContinuar;

  const CardScreen({
    super.key,
    required this.numero,
    required this.textoBotao,
    required this.aoContinuar,
  });

  @override
  Widget build(BuildContext context) {
    final ehJogadora = !Historia.cards.containsKey(numero);
    final card = Historia.cards[numero] ?? Historia.cardDaJogadora(GameState.instance);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF004D40)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  ehJogadora ? 'Um card novo apareceu na galeria...' : 'Card desbloqueado!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  ehJogadora
                      ? 'Ele tem o seu nome.'
                      : 'Mulheres que criaram as conexões invisíveis da tecnologia.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: CardMulherWidget(card: card),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: aoContinuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(textoBotao, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
