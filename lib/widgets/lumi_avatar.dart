import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Humores da Lumi. Cada um tem uma imagem própria em
/// assets/images/lumi/lumi_<humor>.png e uma animação própria.
enum LumiMood {
  instruindo, // explicando algo (pose neutra, sorrindo)
  pensando, // dando dica ou fazendo pergunta (mão no queixo)
  celebrando, // acerto (pulando de alegria)
  alerta, // erro ou energia baixa (placa de sobrecarga)
}

extension LumiMoodVisual on LumiMood {
  String get assetPath => 'assets/images/lumi/lumi_$name.png';

  /// Cor do brilho atrás da Lumi em cada humor.
  Color get glowColor {
    switch (this) {
      case LumiMood.celebrando:
        return const Color(0xFF7CF5C6);
      case LumiMood.pensando:
        return const Color(0xFF8EC9FF);
      case LumiMood.alerta:
        return const Color(0xFFFF6B5E);
      case LumiMood.instruindo:
        return const Color(0xFF7FE7FF);
    }
  }

  /// Cor de destaque usada em textos e botões ligados ao humor.
  Color get accentColor {
    switch (this) {
      case LumiMood.celebrando:
        return const Color(0xFF2E9E6A);
      case LumiMood.pensando:
        return const Color(0xFF1E6FD9);
      case LumiMood.alerta:
        return const Color(0xFFE5483A);
      case LumiMood.instruindo:
        return const Color(0xFFE65100);
    }
  }
}

/// A Lumi animada (poses inteiras, sem articulação).
///
/// - instruindo: flutua e "respira"
/// - pensando: flutua devagar e balança de leve
/// - celebrando: pulinhos com amassadinho ao cair
/// - alerta: tremida e brilho vermelho pulsando
///
/// Ao trocar de humor, a nova pose entra com um pulinho elástico.
class LumiAvatar extends StatefulWidget {
  final LumiMood mood;
  final double height;
  final bool showGlow;

  /// Mantido para compatibilidade: quando o texto muda, a Lumi dá um
  /// pequeno "aceno" de cabeça, como se começasse a falar.
  final String? fala;

  const LumiAvatar({
    super.key,
    this.mood = LumiMood.instruindo,
    this.height = 160,
    this.showGlow = true,
    this.fala,
  });

  @override
  State<LumiAvatar> createState() => _LumiAvatarState();
}

class _LumiAvatarState extends State<LumiAvatar> with TickerProviderStateMixin {
  late final AnimationController _loop;
  late final AnimationController _pop;
  late final AnimationController _nod;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _pop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _nod = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carrega as 4 poses de antemão para a troca de humor não "piscar".
    if (!_precached) {
      _precached = true;
      for (final mood in LumiMood.values) {
        precacheImage(AssetImage(mood.assetPath), context);
      }
    }
  }

  @override
  void didUpdateWidget(covariant LumiAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) {
      _pop.forward(from: 0);
    } else if (oldWidget.fala != widget.fala) {
      _nod.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    _pop.dispose();
    _nod.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final w = h * 0.82;

    final image = AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ),
      child: Image.asset(
        widget.mood.assetPath,
        key: ValueKey(widget.mood),
        height: h,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        semanticLabel: 'Lumi, ${widget.mood.name}',
      ),
    );

    return SizedBox(
      width: w,
      height: h * 1.1,
      child: AnimatedBuilder(
        animation: Listenable.merge([_loop, _pop, _nod]),
        child: image,
        builder: (context, child) {
          final t = _loop.value; // 0..1, repete sem parar
          final wave = math.sin(t * 2 * math.pi);
          final pulse = 0.5 + 0.5 * wave;

          double dx = 0;
          double dy = 0;
          double angle = 0;
          double scaleX = 1;
          double scaleY = 1;
          double hop = 0;

          switch (widget.mood) {
            case LumiMood.instruindo:
              dy = wave * h * 0.018;
              // respiração: estica e encolhe bem de leve
              scaleY = 1 + 0.012 * math.sin(t * 2 * math.pi * 2);
              scaleX = 1 - 0.006 * math.sin(t * 2 * math.pi * 2);
              break;
            case LumiMood.pensando:
              dy = wave * h * 0.01;
              angle = math.sin(t * 2 * math.pi) * 0.03;
              break;
            case LumiMood.celebrando:
              // 3 pulinhos por ciclo; amassa ao tocar o chão
              final phase = (t * 3) % 1.0;
              hop = math.sin(math.pi * phase);
              dy = -hop * h * 0.09;
              final landing = phase < 0.12 ? 1 - phase / 0.12 : (phase > 0.9 ? (phase - 0.9) / 0.1 : 0.0);
              scaleY = 1 - 0.07 * landing + 0.03 * hop;
              scaleX = 1 + 0.06 * landing - 0.02 * hop;
              angle = math.sin(t * 2 * math.pi * 3) * 0.04;
              break;
            case LumiMood.alerta:
              final shaking = t < 0.3 ? (1 - t / 0.3) : 0.0;
              dx = math.sin(t * 2 * math.pi * 14) * h * 0.02 * shaking;
              angle = math.sin(t * 2 * math.pi * 14) * 0.02 * shaking;
              break;
          }

          // entrada elástica ao trocar de humor (amassa e estica)
          final p = _pop.value.clamp(0.0, 1.0);
          final spring = Curves.elasticOut.transform(p);
          scaleY *= 0.80 + 0.20 * spring;
          scaleX *= 1.12 - 0.12 * spring;

          // "aceno" de cabeça quando começa a falar
          final n = _nod.value;
          angle += math.sin(n * math.pi) * 0.04;
          dy += math.sin(n * math.pi) * h * 0.01;

          final glow = widget.mood.glowColor;

          return Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              if (widget.showGlow)
                Positioned(
                  top: h * 0.08,
                  child: Container(
                    width: w * 1.05,
                    height: w * 1.05,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          glow.withAlpha((70 + 70 * pulse).round()),
                          glow.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ),
              // sombra no chão diminui quando a Lumi sobe
              Positioned(
                bottom: 0,
                child: Container(
                  width: w * (0.55 - 0.18 * hop),
                  height: h * 0.035,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black.withAlpha((40 - 20 * hop).round()),
                  ),
                ),
              ),
              Positioned(
                bottom: h * 0.02,
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: Transform.rotate(
                    angle: angle,
                    alignment: Alignment.bottomCenter,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
