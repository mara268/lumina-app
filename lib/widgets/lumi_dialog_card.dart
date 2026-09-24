import 'package:flutter/material.dart';

enum LumiMood {
  instruindo, // Ícone de lâmpada/brilho padrão
  pensando,   // Ícone de engrenagem/dúvida
  celebrando, // Ícone de estrela/festa
  alerta,     // Ícone de atenção
}

class LumiDialogCard extends StatefulWidget {
  final String text;
  final LumiMood mood;

  const LumiDialogCard({
    super.key,
    required this.text,
    this.mood = LumiMood.instruindo,
  });

  @override
  State<LumiDialogCard> createState() => _LumiDialogCardState();
}

class _LumiDialogCardState extends State<LumiDialogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getMoodIcon() {
    switch (widget.mood) {
      case LumiMood.celebrando:
        return Icons.celebration_rounded;
      case LumiMood.pensando:
        return Icons.psychology_alt_rounded;
      case LumiMood.alerta:
        return Icons.tips_and_updates_rounded;
      case LumiMood.instruindo:
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Color _getBadgeColor() {
    switch (widget.mood) {
      case LumiMood.celebrando:
        return Colors.green.shade600;
      case LumiMood.pensando:
        return Colors.blue.shade600;
      case LumiMood.alerta:
        return Colors.deepOrange.shade600;
      case LumiMood.instruindo:
      default:
        return const Color(0xFFFF6F00);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFFFE0B2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getBadgeColor(),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getBadgeColor().withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _getMoodIcon(),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lumi diz:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getBadgeColor(),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: Color(0xFF37474F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}