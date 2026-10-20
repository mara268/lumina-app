import 'package:flutter/services.dart' show rootBundle;

import '../models/game_state.dart';
import '../widgets/lumi_avatar.dart';
import 'historia.dart';

/// Lê a história escrita no Twine (arquivo .twee em assets/historia/)
/// e entrega as passagens prontas para o app mostrar.
///
/// Formato de cada linha dentro de uma passagem:
///   Nome (expressão): fala            → diálogo
///   Elenco: Lumi, Jogadora            → quem aparece no palco
///   Mostrar: bilhete | texto          → bilhete na tela
///   Mostrar: foto | título | ano | ícone
///   (set: $variavel to "valor")       → guarda uma escolha
///   (go-to: "Passagem")               → pula para outra passagem
///   (if: $variavel is "valor")[linha] / (else-if: ...)[linha] / (else:)[linha]
///   [[TEXTO DO BOTÃO->Passagem]]      → botão (vários = escolha)
class Roteiro {
  Roteiro._();
  static final Roteiro instancia = Roteiro._();

  static const String arquivo = 'assets/historia/lumina.twee';

  final Map<String, Passagem> passagens = {};
  String inicio = '';
  bool carregado = false;

  /// Carrega o arquivo do Twine (chamado uma vez, ao abrir o app).
  static Future<void> carregar() async {
    final texto = await rootBundle.loadString(arquivo);
    instancia.interpretar(texto);
  }

  Passagem? passagem(String nome) => passagens[nome];

  /// Botão que vem depois da fase N (definido na passagem "Fase N" do Twine).
  Link? linkDepoisDaFase(int fase) {
    final p = passagens['Fase $fase'];
    if (p == null || p.links.isEmpty) return null;
    return p.links.first;
  }

  // ----------------------------------------------------------------- leitura

  static final RegExp _cabecalho = RegExp(r'^::\s*(.+?)\s*(?:\[([^\]]*)\])?\s*(?:\{.*\})?\s*$');
  static final RegExp _inicio = RegExp(r'"start"\s*:\s*"([^"]+)"');
  static final RegExp _link = RegExp(r'\[\[(.+?)\]\]');
  static final RegExp _se = RegExp(r'^\((if|else-if|elseif):\s*\$(\w+)\s+is\s+"([^"]*)"\s*\)\[(.*)\]$');
  static final RegExp _senao = RegExp(r'^\(else:\s*\)\[(.*)\]$');
  static final RegExp _set = RegExp(r'^\(set:\s*\$(\w+)\s+to\s+"([^"]*)"\s*\)$');
  static final RegExp _goTo = RegExp(r'^\(go-?to:\s*"([^"]+)"\s*\)$');
  static final RegExp _elenco = RegExp(r'^elenco\s*:\s*(.+)$', caseSensitive: false);
  static final RegExp _mostrar = RegExp(r'^mostrar\s*:\s*(.+)$', caseSensitive: false);
  static final RegExp _fala = RegExp(r'^([^:()\[\]]+?)\s*(?:\(([^)]*)\))?\s*:\s*(.+)$');

  void interpretar(String texto) {
    passagens.clear();
    inicio = '';
    String? nomeAtual;
    List<String> tagsAtuais = [];
    final linhas = <String>[];

    void fechar() {
      final nome = nomeAtual;
      if (nome == null) return;
      if (nome == 'StoryData') {
        final m = _inicio.firstMatch(linhas.join('\n'));
        if (m != null) inicio = m.group(1)!;
      } else if (nome != 'StoryTitle') {
        passagens[nome] = _lerPassagem(nome, tagsAtuais, linhas);
      }
      linhas.clear();
    }

    for (final bruta in texto.replaceAll('\r\n', '\n').split('\n')) {
      final cab = bruta.startsWith('::') ? _cabecalho.firstMatch(bruta) : null;
      if (cab != null) {
        fechar();
        nomeAtual = cab.group(1)!.trim();
        tagsAtuais = (cab.group(2) ?? '').split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
      } else {
        linhas.add(bruta);
      }
    }
    fechar();

    if (inicio.isEmpty && passagens.isNotEmpty) inicio = passagens.keys.first;
    carregado = true;
  }

  Passagem _lerPassagem(String nome, List<String> tags, List<String> linhas) {
    final itens = <ItemCena>[];
    final links = <Link>[];
    // condições do bloco if / else-if / else em andamento
    List<Teste> cadeia = [];

    for (final bruta in linhas) {
      var linha = bruta.trim();
      if (linha.isEmpty || linha.startsWith('<!--')) continue;

      // botões (normalmente sozinhos na linha); o resto da linha segue normal
      final achados = _link.allMatches(linha).toList();
      if (achados.isNotEmpty) {
        for (final m in achados) {
          links.add(Link.interpretar(m.group(1)!));
        }
        linha = linha.replaceAll(_link, '').trim();
        if (linha.isEmpty) continue;
      }

      final se = _se.firstMatch(linha);
      if (se != null) {
        final teste = Teste(se.group(2)!, se.group(3)!);
        final ehSenaoSe = se.group(1) != 'if';
        final condicao = Condicao(todas: [teste], nenhuma: ehSenaoSe ? List.of(cadeia) : const []);
        cadeia = ehSenaoSe ? [...cadeia, teste] : [teste];
        final item = _lerLinha(se.group(4)!.trim(), condicao);
        if (item != null) itens.add(item);
        continue;
      }

      final senao = _senao.firstMatch(linha);
      if (senao != null) {
        final condicao = Condicao(todas: const [], nenhuma: List.of(cadeia));
        cadeia = [];
        final item = _lerLinha(senao.group(1)!.trim(), condicao);
        if (item != null) itens.add(item);
        continue;
      }

      cadeia = [];
      final item = _lerLinha(linha, Condicao.sempre);
      if (item != null) itens.add(item);
    }

    return Passagem(nome: nome, tags: tags, itens: itens, links: links);
  }

  ItemCena? _lerLinha(String linha, Condicao condicao) {
    final set = _set.firstMatch(linha);
    if (set != null) {
      return ItemCena(TipoItem.variavel, condicao, partes: [set.group(1)!, set.group(2)!]);
    }
    final goTo = _goTo.firstMatch(linha);
    if (goTo != null) {
      return ItemCena(TipoItem.irPara, condicao, partes: [goTo.group(1)!]);
    }
    final elenco = _elenco.firstMatch(linha);
    if (elenco != null) {
      final nomes = elenco.group(1)!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
      return ItemCena(TipoItem.elenco, condicao, partes: nomes.toList());
    }
    final mostrar = _mostrar.firstMatch(linha);
    if (mostrar != null) {
      final partes = mostrar.group(1)!.split('|').map((e) => e.trim()).toList();
      return ItemCena(TipoItem.mostrar, condicao, partes: partes);
    }
    final fala = _fala.firstMatch(linha);
    if (fala != null) {
      final quem = personagemPorNome(fala.group(1)!);
      if (quem != null) {
        return ItemCena(
          TipoItem.fala,
          condicao,
          fala: _criarFala(quem, (fala.group(2) ?? '').trim().toLowerCase(), fala.group(3)!.trim()),
        );
      }
    }
    // qualquer outro texto vira narração
    return ItemCena(TipoItem.fala, condicao, fala: Fala(Personagem.narrador, linha));
  }

  static Personagem? personagemPorNome(String nome) {
    switch (nome.trim().toLowerCase()) {
      case 'narrador':
      case 'narradora':
        return Personagem.narrador;
      case 'jogadora':
      case 'neta':
        return Personagem.jogadora;
      case 'lumi':
        return Personagem.lumi;
      case 'helena':
      case 'vó helena':
      case 'vo helena':
        return Personagem.helena;
      case 'valdir':
      case 'seu valdir':
        return Personagem.valdir;
      default:
        return null;
    }
  }

  static Fala _criarFala(Personagem quem, String expressao, String texto) {
    if (quem == Personagem.lumi) {
      final humor = LumiMood.values.where((m) => m.name == expressao);
      return Fala(quem, texto, humor: humor.isEmpty ? LumiMood.instruindo : humor.first);
    }
    final exp = Expressao.values.where((e) => e.name == expressao);
    return Fala(quem, texto, expressao: exp.isEmpty ? Expressao.neutra : exp.first);
  }
}

// ------------------------------------------------------------------ modelos

class Link {
  final String texto;
  final String destino;

  const Link(this.texto, this.destino);

  /// Aceita [[texto->destino]], [[destino<-texto]], [[texto|destino]] e [[destino]].
  factory Link.interpretar(String dentro) {
    final seta = dentro.lastIndexOf('->');
    if (seta >= 0) return Link(dentro.substring(0, seta).trim(), dentro.substring(seta + 2).trim());
    final volta = dentro.indexOf('<-');
    if (volta >= 0) return Link(dentro.substring(volta + 2).trim(), dentro.substring(0, volta).trim());
    final barra = dentro.lastIndexOf('|');
    if (barra >= 0) return Link(dentro.substring(0, barra).trim(), dentro.substring(barra + 1).trim());
    return Link(dentro.trim(), dentro.trim());
  }
}

enum TipoItem { fala, elenco, mostrar, variavel, irPara }

/// Uma linha da passagem, com a condição para ela valer.
class ItemCena {
  final TipoItem tipo;
  final Condicao condicao;
  final Fala? fala;
  final List<String> partes;

  const ItemCena(this.tipo, this.condicao, {this.fala, this.partes = const []});

  bool get vale => condicao.avaliar();
}

/// Teste "variável é valor".
class Teste {
  final String variavel;
  final String valor;

  const Teste(this.variavel, this.valor);

  bool avaliar() => GameState.instance.valorDaVariavel(variavel) == valor;
}

/// A linha vale se TODOS os testes de [todas] forem verdadeiros e
/// NENHUM de [nenhuma] for (é assim que o else / else-if funciona).
class Condicao {
  final List<Teste> todas;
  final List<Teste> nenhuma;

  const Condicao({this.todas = const [], this.nenhuma = const []});

  static const Condicao sempre = Condicao();

  bool avaliar() => todas.every((t) => t.avaliar()) && !nenhuma.any((t) => t.avaliar());
}

class Passagem {
  final String nome;
  final List<String> tags;
  final List<ItemCena> itens;
  final List<Link> links;

  const Passagem({required this.nome, required this.tags, required this.itens, required this.links});

  bool tem(String tag) => tags.contains(tag);

  /// Número no nome ("Fase 3", "Memoria 4 Estufa", "Card 2" → 3, 4, 2).
  int? get numero {
    final m = RegExp(r'(\d+)').firstMatch(nome);
    return m == null ? null : int.parse(m.group(1)!);
  }

  /// Itens que valem agora (conforme as escolhas já feitas).
  List<ItemCena> get itensValidos => itens.where((i) => i.vale).toList();

  /// Primeiro (go-to) que vale, se houver.
  String? get irPara {
    for (final i in itens) {
      if (i.tipo == TipoItem.irPara && i.vale) return i.partes.first;
    }
    return null;
  }
}
