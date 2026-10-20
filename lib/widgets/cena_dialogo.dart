import 'dart:async';

import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../story/historia.dart';
import 'lumi_avatar.dart';

/// Ambiente visual de uma cena: imagem de cenário (se existir) e, como
/// reserva, um gradiente com ícone.
class AmbienteCena {
  final List<Color> fundo; // gradiente de reserva (de cima para baixo)
  final String? imagem; // assets/images/cenarios/<arquivo>
  final IconData? icone;
  final Color corIcone;
  final bool raios; // relâmpagos piscando (tempestade)

  const AmbienteCena({
    required this.fundo,
    this.imagem,
    this.icone,
    this.corIcone = Colors.white70,
    this.raios = false,
  });

  static const entardecer = AmbienteCena(
    fundo: [Color(0xFFFFB74D), Color(0xFFFF8A65), Color(0xFF5D4037)],
    imagem: 'assets/images/cenarios/entardecer.jpg',
    icone: Icons.cottage,
    corIcone: Color(0xFFFFF3E0),
  );
  static const tempestade = AmbienteCena(
    fundo: [Color(0xFF1A2333), Color(0xFF0D1117)],
    imagem: 'assets/images/cenarios/tempestade.jpg',
    icone: Icons.thunderstorm,
    corIcone: Color(0xFF90A4AE),
    raios: true,
  );
  static const escritorio = AmbienteCena(
    fundo: [Color(0xFF263238), Color(0xFF102027)],
    imagem: 'assets/images/cenarios/escritorio.jpg',
    icone: Icons.memory,
    corIcone: Color(0xFF7FE7FF),
  );
  static const memoria = AmbienteCena(
    fundo: [Color(0xFF4E342E), Color(0xFF3E2723)],
  );
  static const telefone = AmbienteCena(
    fundo: [Color(0xFF37474F), Color(0xFF263238)],
    imagem: 'assets/images/cenarios/sala.jpg',
    icone: Icons.phone_in_talk,
    corIcone: Color(0xFFFFCC80),
  );
  static const amanhecer = AmbienteCena(
    fundo: [Color(0xFF81D4FA), Color(0xFFFFE0B2), Color(0xFFFFCC80)],
    imagem: 'assets/images/cenarios/amanhecer.jpg',
    icone: Icons.wb_sunny,
    corIcone: Color(0xFFFFA000),
  );
}

/// Uma opção de escolha no fim da cena.
class OpcaoCena {
  final String texto;
  final VoidCallback aoEscolher;

  const OpcaoCena(this.texto, this.aoEscolher);
}

/// Cena de diálogo no estilo "visual novel": cenário ao fundo, personagens
/// em pé no palco e um balão de fala embaixo. Quem fala fica em destaque;
/// os outros ficam apagados. Tocar na tela completa a fala ou avança.
class CenaDialogo extends StatefulWidget {
  final List<Fala> falas;
  final AmbienteCena ambiente;
  final String textoBotaoFinal;
  final VoidCallback onFim;

  /// Quem aparece no palco, da esquerda para a direita. Se não for
  /// informado, aparecem todos os que falam na cena (menos o narrador).
  final List<Personagem>? elenco;

  /// Conteúdo opcional no alto da cena (bilhete, foto antiga...).
  final Widget? destaque;

  /// A partir de qual fala (0 = primeira) o destaque aparece.
  final int destaqueAPartirDaFala;

  /// Se houver mais de uma opção, no fim da cena aparecem botões de escolha
  /// no lugar do botão final.
  final List<OpcaoCena> opcoes;

  const CenaDialogo({
    super.key,
    required this.falas,
    required this.ambiente,
    required this.onFim,
    this.textoBotaoFinal = 'CONTINUAR',
    this.elenco,
    this.destaque,
    this.destaqueAPartirDaFala = 0,
    this.opcoes = const [],
  });

  @override
  State<CenaDialogo> createState() => _CenaDialogoState();
}

class _CenaDialogoState extends State<CenaDialogo> with SingleTickerProviderStateMixin {
  int _indice = 0;
  int _letras = 0;
  Timer? _timer;
  late final AnimationController _raio;

  // última expressão/humor de cada personagem nesta cena
  final Map<Personagem, Expressao> _expressoes = {};
  LumiMood _humorLumi = LumiMood.instruindo;

  bool get _ultima => _indice >= widget.falas.length - 1;
  Fala get _fala => widget.falas[_indice];
  String get _textoAtual => _fala.textoPara(GameState.instance);
  bool get _completa => _letras >= _textoAtual.length;

  List<Personagem> get _elenco {
    if (widget.elenco != null) return widget.elenco!;
    final lista = <Personagem>[];
    for (final f in widget.falas) {
      if (f.quem != Personagem.narrador && !lista.contains(f.quem)) lista.add(f.quem);
    }
    // a jogadora fica sempre à direita
    if (lista.remove(Personagem.jogadora)) lista.add(Personagem.jogadora);
    return lista;
  }

  @override
  void initState() {
    super.initState();
    _raio = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));
    if (widget.ambiente.raios) _raio.repeat();
    _aplicarFala();
    _comecarDigitacao();
  }

  void _aplicarFala() {
    final f = _fala;
    if (f.quem == Personagem.lumi) {
      _humorLumi = f.humor;
    } else if (f.quem == Personagem.jogadora || f.quem == Personagem.helena) {
      _expressoes[f.quem] = f.expressao;
    }
  }

  void _comecarDigitacao() {
    _timer?.cancel();
    _letras = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 22), (t) {
      if (!mounted) return;
      setState(() => _letras += 2);
      if (_completa) t.cancel();
    });
  }

  void _tocar() {
    if (!_completa) {
      _timer?.cancel();
      setState(() => _letras = _textoAtual.length);
      return;
    }
    if (_ultima) return; // no fim, só o botão avança
    setState(() {
      _indice++;
      _aplicarFala();
    });
    _comecarDigitacao();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _raio.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ nomes e cores

  static const Color _corJogadora = Color(0xFFE65100);
  static const Color _corHelena = Color(0xFF8E24AA);
  static const Color _corValdir = Color(0xFF546E7A);

  String _nome(Personagem p) {
    switch (p) {
      case Personagem.lumi:
        return 'Lumi';
      case Personagem.jogadora:
        return GameState.instance.nomeOuPadrao;
      case Personagem.helena:
        return 'Vó Helena';
      case Personagem.valdir:
        return 'Seu Valdir (ao telefone)';
      case Personagem.narrador:
        return '';
    }
  }

  Color _cor(Personagem p) {
    switch (p) {
      case Personagem.lumi:
        return _humorLumi.accentColor;
      case Personagem.jogadora:
        return _corJogadora;
      case Personagem.helena:
        return _corHelena;
      case Personagem.valdir:
        return _corValdir;
      case Personagem.narrador:
        return Colors.white;
    }
  }

  // ------------------------------------------------------------ personagens

  /// Imagem de um personagem com reservas: expressão pedida → neutra → silhueta.
  Widget _imagemComReserva(List<String> caminhos, Personagem p, double altura) {
    Widget silhueta() => _Silhueta(cor: _cor(p), altura: altura, rotulo: _nome(p));
    Widget tentar(int i) {
      if (i >= caminhos.length) return silhueta();
      return Image.asset(
        caminhos[i],
        height: altura,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stack) => tentar(i + 1),
      );
    }

    return tentar(0);
  }

  Widget _personagem(Personagem p, double altura) {
    switch (p) {
      case Personagem.lumi:
        return LumiAvatar(mood: _humorLumi, height: altura * 0.9, fala: _fala.quem == p ? _fala.texto : null);
      case Personagem.jogadora:
        final a = GameState.instance.avatar;
        final e = (_expressoes[p] ?? Expressao.neutra).name;
        return _imagemComReserva([
          'assets/images/personagens/neta_${a}_$e.png',
          'assets/images/personagens/neta_${a}_neutra.png',
        ], p, altura);
      case Personagem.helena:
        final e = (_expressoes[p] ?? Expressao.neutra).name;
        return _imagemComReserva([
          'assets/images/personagens/helena_$e.png',
          'assets/images/personagens/helena_neutra.png',
        ], p, altura);
      case Personagem.valdir:
        return _imagemComReserva(['assets/images/personagens/valdir.png'], p, altura);
      case Personagem.narrador:
        return const SizedBox.shrink();
    }
  }

  Widget _palco(double altura) {
    final elenco = _elenco;
    if (elenco.isEmpty) return SizedBox(height: altura * 0.2);
    return SizedBox(
      height: altura,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final p in elenco)
            Expanded(
              child: _NoPalco(
                falando: _fala.quem == p,
                // anima de novo a cada nova fala desse personagem
                chave: _fala.quem == p ? _indice : -1,
                child: _personagem(p, altura),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ balão

  Widget _balao() {
    final fala = _fala;
    final narrador = fala.quem == Personagem.narrador;
    final texto = _textoAtual.substring(0, _letras.clamp(0, _textoAtual.length));
    final cor = _cor(fala.quem);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: narrador ? Colors.black.withAlpha(170) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: narrador ? Colors.white24 : cor.withAlpha(140),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 14, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!narrador)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(100)),
              child: Text(
                _nome(fala.quem),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          Text(
            texto,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.5,
              fontStyle: narrador ? FontStyle.italic : FontStyle.normal,
              color: narrador ? Colors.white : const Color(0xFF37474F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ fundo

  Widget _fundo(bool flash) {
    final amb = widget.ambiente;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: amb.fundo,
            ),
          ),
          child: amb.icone == null || (widget.destaque != null && _indice >= widget.destaqueAPartirDaFala)
              ? null
              : Align(
                  alignment: const Alignment(0, -0.55),
                  child: Icon(amb.icone, size: 110, color: amb.corIcone.withAlpha(120)),
                ),
        ),
        if (amb.imagem != null)
          Image.asset(
            amb.imagem!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => const SizedBox.shrink(),
          ),
        // escurece a parte de baixo para o texto ficar legível
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.45, 1.0],
              colors: [Colors.transparent, Color(0xAA000000)],
            ),
          ),
        ),
        if (flash) Container(color: Colors.white.withAlpha(150)),
      ],
    );
  }

  /// Parte de baixo: "toque para continuar", o botão final ou as escolhas.
  Widget _rodape() {
    if (!(_ultima && _completa)) {
      return SizedBox(
        height: 54,
        child: Center(
          child: Text(
            'toque para continuar  ▸',
            style: TextStyle(color: Colors.white.withAlpha(190), fontSize: 13),
          ),
        ),
      );
    }

    if (widget.opcoes.length > 1) {
      return Column(
        children: [
          for (final opcao in widget.opcoes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OutlinedButton(
                onPressed: opcao.aoEscolher,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black.withAlpha(90),
                  side: const BorderSide(color: Color(0xFFFFCC80), width: 1.5),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  opcao.texto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      );
    }

    return ElevatedButton(
      onPressed: widget.opcoes.length == 1 ? widget.opcoes.first.aoEscolher : widget.onFim,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE65100),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        widget.opcoes.length == 1 ? widget.opcoes.first.texto : widget.textoBotaoFinal,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela = MediaQuery.of(context).size.height;
    final alturaPalco = (alturaTela * 0.40).clamp(180.0, 360.0);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _tocar,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _raio,
              builder: (context, _) {
                final v = _raio.value;
                final flash = widget.ambiente.raios && ((v > 0.10 && v < 0.13) || (v > 0.16 && v < 0.18));
                return _fundo(flash);
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: widget.destaque == null || _indice < widget.destaqueAPartirDaFala
                            ? const SizedBox.shrink(key: ValueKey('sem-destaque'))
                            : Center(
                                key: const ValueKey('destaque'),
                                child: FittedBox(fit: BoxFit.scaleDown, child: widget.destaque),
                              ),
                      ),
                    ),
                    _palco(alturaPalco),
                    const SizedBox(height: 8),
                    _balao(),
                    const SizedBox(height: 10),
                    _rodape(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Personagem no palco: em destaque quando fala, apagado quando não fala.
/// Dá um pulinho sempre que começa uma fala nova.
class _NoPalco extends StatelessWidget {
  final bool falando;
  final int chave;
  final Widget child;

  const _NoPalco({required this.falando, required this.chave, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: falando ? 1.0 : 0.55,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: falando ? 1.0 : 0.92,
        alignment: Alignment.bottomCenter,
        child: TweenAnimationBuilder<double>(
          key: ValueKey(chave),
          tween: Tween(begin: falando ? 1.0 : 0.0, end: 0.0),
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOut,
          builder: (context, v, child) => Transform.translate(
            offset: Offset(0, -10 * v),
            child: child,
          ),
          child: Align(alignment: Alignment.bottomCenter, child: child),
        ),
      ),
    );
  }
}

/// Silhueta provisória enquanto a imagem do personagem não existe.
class _Silhueta extends StatelessWidget {
  final Color cor;
  final double altura;
  final String rotulo;

  const _Silhueta({required this.cor, required this.altura, required this.rotulo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: altura,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // silhueta grande (do tamanho de uma pessoa no palco)
          Icon(
            Icons.person,
            size: altura * 0.82,
            color: cor.withAlpha(200),
            shadows: [Shadow(color: Colors.black.withAlpha(120), blurRadius: 12)],
          ),
          Text(
            rotulo,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
