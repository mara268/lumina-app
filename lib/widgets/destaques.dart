import 'package:flutter/material.dart';

/// Bilhete preso com alfinete (ex.: o bilhete da vó Helena).
class BilheteDestaque extends StatelessWidget {
  final String texto;

  const BilheteDestaque({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.03,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 16, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.push_pin, color: Color(0xFFE53935), size: 22),
            const SizedBox(height: 8),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 15,
                height: 1.55,
                color: Color(0xFF4E342E),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Foto antiga" de uma memória da Lumi.
class FotoAntigaDestaque extends StatelessWidget {
  final String titulo;
  final String ano;
  final String icone; // radio, escola, planta, casa, livro, video
  final String? rotulo; // texto acima da foto (ex.: "MEMÓRIA 1 DE 5 RECUPERADA")

  const FotoAntigaDestaque({
    super.key,
    required this.titulo,
    required this.ano,
    required this.icone,
    this.rotulo,
  });

  static IconData iconePorNome(String nome) {
    switch (nome.trim().toLowerCase()) {
      case 'radio':
      case 'rádio':
        return Icons.radio;
      case 'escola':
        return Icons.school;
      case 'planta':
        return Icons.local_florist;
      case 'casa':
        return Icons.architecture;
      case 'livro':
      case 'diario':
      case 'diário':
        return Icons.menu_book;
      case 'video':
      case 'vídeo':
        return Icons.videocam;
      default:
        return Icons.photo_camera;
    }
  }

  @override
  Widget build(BuildContext context) {
    final foto = Transform.rotate(
      angle: 0.04,
      child: Container(
        width: 230,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0E6),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(90), blurRadius: 18, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 170,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFBCAAA4), Color(0xFF8D6E63)],
                ),
              ),
              child: Icon(iconePorNome(icone), size: 90, color: const Color(0xFF4E342E).withAlpha(200)),
            ),
            const SizedBox(height: 10),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4E342E)),
            ),
            Text(
              ano,
              style: const TextStyle(fontSize: 13, color: Color(0xFF795548), fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );

    if (rotulo == null) return foto;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rotulo!,
          style: const TextStyle(
            color: Color(0xFFFFCC80),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        foto,
      ],
    );
  }
}
