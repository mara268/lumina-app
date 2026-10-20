import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../story/roteiro.dart';
import '../widgets/cena_dialogo.dart';
import 'passagem_screen.dart';

/// Antes da história: a jogadora diz o nome e escolhe o avatar.
/// Depois, a história começa pela passagem inicial do Twine.
class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  bool _escolhendoAvatar = false;
  String? _avatar;
  final TextEditingController _nome = TextEditingController();

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  void _confirmarNome() {
    if (_nome.text.trim().isEmpty) return;
    GameState.instance.definirNome(_nome.text);
    FocusScope.of(context).unfocus();
    setState(() => _escolhendoAvatar = true);
  }

  void _comecarHistoria() {
    GameState.instance.definirAvatar(_avatar!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PassagemScreen(nome: Roteiro.instancia.inicio)),
    );
  }

  BoxDecoration get _fundo => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AmbienteCena.entardecer.fundo,
        ),
      );

  ButtonStyle get _estiloBotao => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE65100),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  Widget _telaNome() {
    return Column(
      key: const ValueKey('nome'),
      children: [
        const Icon(Icons.cottage, size: 90, color: Color(0xFFFFF3E0)),
        const SizedBox(height: 20),
        const Text(
          'Antes de começar...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text('Qual é o seu nome?', style: TextStyle(fontSize: 16, color: Colors.white)),
        const SizedBox(height: 20),
        TextField(
          controller: _nome,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          textAlign: TextAlign.center,
          maxLength: 20,
          onSubmitted: (_) => _confirmarNome(),
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            hintText: 'Digite seu nome',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _nome.text.trim().isEmpty ? null : _confirmarNome,
          style: _estiloBotao,
          child: const Text('CONTINUAR', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _opcaoAvatar(String id, int numero) {
    final selecionado = _avatar == id;
    const coresReserva = [Color(0xFF8D6E63), Color(0xFFFFB74D), Color(0xFF5D4037)];
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _avatar = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selecionado ? Colors.white : Colors.white.withAlpha(60),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selecionado ? const Color(0xFFE65100) : Colors.white54,
              width: selecionado ? 3 : 1.5,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 170,
                child: Image.asset(
                  'assets/images/personagens/neta_${id}_neutra.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => Icon(
                    Icons.person,
                    size: 150,
                    color: coresReserva[numero - 1],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Opção $numero',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selecionado ? const Color(0xFFE65100) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _telaAvatar() {
    return Column(
      key: const ValueKey('avatar'),
      children: [
        Text(
          'Olá, ${GameState.instance.nomeOuPadrao}!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        const Text(
          'Como você quer aparecer na história?',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _opcaoAvatar('a', 1),
            _opcaoAvatar('b', 2),
            _opcaoAvatar('c', 3),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _avatar == null ? null : _comecarHistoria,
          style: _estiloBotao,
          child: const Text('CHEGAR À CASA DA VÓ', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _fundo,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _escolhendoAvatar ? _telaAvatar() : _telaNome(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
