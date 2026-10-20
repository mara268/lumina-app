import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game_state.dart';
import 'lumi_avatar.dart';

/// Mostra a Lumi em tela cheia reagindo ao que a jogadora fez.
///
/// Uso no acerto:
/// ```dart
/// await mostrarReacaoLumi(
///   context,
///   mood: LumiMood.celebrando,
///   titulo: 'Isso aí!',
///   mensagem: 'Você acabou de escrever seu primeiro algoritmo.',
/// );
/// ```
///
/// Uso no erro:
/// ```dart
/// await mostrarReacaoLumi(
///   context,
///   mood: LumiMood.alerta,
///   titulo: 'Ops! Quase lá',
///   mensagem: 'Quem vem primeiro: perceber ou agir?',
///   textoBotao: 'TENTAR DE NOVO',
/// );
/// ```
Future<void> mostrarReacaoLumi(
  BuildContext context, {
  required LumiMood mood,
  required String titulo,
  required String mensagem,
  String textoBotao = 'CONTINUAR',
  int? energia,
}) {
  // Energia do gerador: acerto devolve 10, erro gasta 5 (ou o valor informado).
  final variacao = energia ??
      (mood == LumiMood.celebrando
          ? 10
          : mood == LumiMood.alerta
              ? -5
              : 0);
  if (variacao > 0) GameState.instance.ganharEnergia(variacao);
  if (variacao < 0) GameState.instance.gastarEnergia(-variacao);

  if (mood == LumiMood.celebrando) {
    HapticFeedback.lightImpact();
  } else if (mood == LumiMood.alerta) {
    HapticFeedback.mediumImpact();
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Reação da Lumi',
    barrierColor: Colors.black.withAlpha(150),
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _LumiReactionView(
        mood: mood,
        titulo: titulo,
        mensagem: mensagem,
        textoBotao: textoBotao,
        variacaoEnergia: variacao,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _LumiReactionView extends StatefulWidget {
  final LumiMood mood;
  final String titulo;
  final String mensagem;
  final String textoBotao;
  final int variacaoEnergia;

  const _LumiReactionView({
    required this.mood,
    required this.titulo,
    required this.mensagem,
    required this.textoBotao,
    this.variacaoEnergia = 0,
  });

  @override
  State<_LumiReactionView> createState() => _LumiReactionViewState();
}

class _LumiReactionViewState extends State<_LumiReactionView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confetti;
  late final List<_Particle> _particles;

  bool get _comemorando => widget.mood == LumiMood.celebrando;

  @override
  void initState() {
    super.initState();
    _confetti = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    final rnd = math.Random();
    _particles = List.generate(_comemorando ? 90 : 0, (_) => _Particle(rnd));
    if (_comemorando) _confetti.forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Widget _chipEnergia(int variacao) {
    final positivo = variacao > 0;
    final cor = positivo ? const Color(0xFF2E9E6A) : const Color(0xFFE5483A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withAlpha(25),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: cor.withAlpha(120)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, size: 16, color: cor),
          Text(
            '${positivo ? '+' : '−'}${variacao.abs()} de energia do gerador',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: cor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.mood.accentColor;
    final screenH = MediaQuery.of(context).size.height;
    final lumiHeight = math.min(280.0, screenH * 0.38);

    return Stack(
      children: [
        if (_comemorando)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _confetti,
                builder: (context, _) => CustomPaint(
                  painter: _ConfettiPainter(_particles, _confetti.value),
                ),
              ),
            ),
          ),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LumiAvatar(
                        mood: widget.mood,
                        height: lumiHeight,
                        fala: widget.mensagem,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: accent.withAlpha(90), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withAlpha(60),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.titulo,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: accent,
                              ),
                            ),
                            if (widget.variacaoEnergia != 0) ...[
                              const SizedBox(height: 8),
                              _chipEnergia(widget.variacaoEnergia),
                            ],
                            const SizedBox(height: 10),
                            Text(
                              widget.mensagem,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15.5,
                                height: 1.5,
                                color: Color(0xFF37474F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                widget.textoBotao,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Um pedacinho de confete.
class _Particle {
  final double x; // posição horizontal inicial (0..1 da largura)
  final double delay; // quando começa a cair (0..0.35)
  final double speed; // velocidade de queda
  final double drift; // balanço lateral
  final double spin; // velocidade de rotação
  final double size;
  final Color color;
  final bool round;

  static const _colors = [
    Color(0xFF7FE7FF),
    Color(0xFFFFC94D),
    Color(0xFFFF8A65),
    Color(0xFF7CF5C6),
    Color(0xFFB39DFF),
    Color(0xFFFF6FA8),
  ];

  _Particle(math.Random r)
      : x = r.nextDouble(),
        delay = r.nextDouble() * 0.35,
        speed = 0.7 + r.nextDouble() * 0.6,
        drift = (r.nextDouble() - 0.5) * 0.12,
        spin = (r.nextDouble() - 0.5) * 14,
        size = 6 + r.nextDouble() * 7,
        color = _colors[r.nextInt(_colors.length)],
        round = r.nextBool();
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final local = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final y = -20 + local * p.speed * (size.height + 40);
      final x = (p.x + math.sin(local * math.pi * 3) * p.drift) * size.width;
      final fade = local > 0.8 ? (1 - local) / 0.2 : 1.0;
      paint.color = p.color.withAlpha((255 * fade).round());

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(local * p.spin);
      if (p.round) {
        canvas.drawCircle(Offset.zero, p.size * 0.45, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.progress != progress;
}
