import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../story/historia.dart';
import '../story/recursos.dart';

/// Card "Conexões Invisíveis". Começa virado (verso) e gira para mostrar
/// a frente quando [revelar] é verdadeiro.
class CardMulherWidget extends StatefulWidget {
  final CardMulher card;
  final bool revelar;
  final bool compacto; // versão pequena para a galeria final

  const CardMulherWidget({
    super.key,
    required this.card,
    this.revelar = true,
    this.compacto = false,
  });

  @override
  State<CardMulherWidget> createState() => _CardMulherWidgetState();
}

class _CardMulherWidgetState extends State<CardMulherWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _giro;

  @override
  void initState() {
    super.initState();
    _giro = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    if (widget.revelar) {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) _giro.forward();
      });
    }
  }

  @override
  void didUpdateWidget(covariant CardMulherWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revelar && !oldWidget.revelar) _giro.forward();
  }

  @override
  void dispose() {
    _giro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _giro,
      builder: (context, _) {
        final angulo = Curves.easeInOut.transform(_giro.value) * math.pi;
        final mostrandoFrente = angulo > math.pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angulo),
          child: mostrandoFrente
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: _frente(),
                )
              : _verso(),
        );
      },
    );
  }

  BoxDecoration _moldura(Color cor) => BoxDecoration(
        borderRadius: BorderRadius.circular(widget.compacto ? 14 : 20),
        border: Border.all(color: const Color(0xFFFFC107), width: widget.compacto ? 2 : 3),
        boxShadow: [
          BoxShadow(color: cor.withAlpha(80), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      );

  Widget _verso() {
    return Container(
      width: double.infinity,
      height: widget.compacto ? 170 : 360,
      decoration: _moldura(const Color(0xFF283593)).copyWith(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF283593), Color(0xFF00838F)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hub, color: const Color(0xFF7FE7FF), size: widget.compacto ? 36 : 64),
          const SizedBox(height: 10),
          Text(
            'CONEXÕES\nINVISÍVEIS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: widget.compacto ? 12 : 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Retrato redondo: a imagem do card, se existir; senão, as iniciais.
  Widget _retrato(CardMulher c, bool compacto) {
    final temImagem = c.imagem != null && Recursos.carregadoComSucesso && Recursos.existe(c.imagem!);
    final tamanho = compacto ? 54.0 : (temImagem ? 130.0 : 96.0);

    final iniciais = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c.cor, c.cor.withAlpha(150)]),
      ),
      child: Text(
        c.iniciais,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: compacto ? 20 : 34,
        ),
      ),
    );

    return Container(
      width: tamanho,
      height: tamanho,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.cor.withAlpha(40),
      ),
      child: temImagem
          ? Image.asset(
              c.imagem!,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, erro, pilha) => iniciais,
            )
          : iniciais,
    );
  }

  Widget _frente() {
    final c = widget.card;
    final compacto = widget.compacto;
    return Container(
      width: double.infinity,
      height: compacto ? 170 : null,
      constraints: compacto ? null : const BoxConstraints(minHeight: 360),
      padding: EdgeInsets.all(compacto ? 10 : 20),
      decoration: _moldura(c.cor).copyWith(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _retrato(c, compacto),
          SizedBox(height: compacto ? 6 : 12),
          Text(
            c.nome,
            textAlign: TextAlign.center,
            maxLines: compacto ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compacto ? 13 : 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2D3142),
            ),
          ),
          Text(
            c.periodo,
            style: TextStyle(fontSize: compacto ? 11 : 13, color: Colors.grey.shade600),
          ),
          if (!compacto) ...[
            const SizedBox(height: 12),
            Text(
              c.descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF37474F)),
            ),
          ],
          SizedBox(height: compacto ? 4 : 14),
          Text(
            '"${c.frase}"',
            textAlign: TextAlign.center,
            maxLines: compacto ? 3 : 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compacto ? 11 : 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: c.cor,
            ),
          ),
        ],
      ),
    );
  }
}
