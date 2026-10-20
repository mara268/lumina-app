import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../widgets/lumi_avatar.dart';

/// Quem está falando numa cena.
enum Personagem { lumi, jogadora, helena, valdir, narrador }

/// Expressão de rosto da jogadora e da vó Helena (escolhe a imagem).
enum Expressao { neutra, surpresa, feliz }

/// Uma fala da história. Use {nome} no texto para o nome da jogadora.
class Fala {
  final Personagem quem;
  final String texto;
  final LumiMood humor; // só usado quando quem == lumi
  final Expressao expressao; // usado para jogadora e helena

  const Fala(
    this.quem,
    this.texto, {
    this.humor = LumiMood.instruindo,
    this.expressao = Expressao.neutra,
  });

  String textoPara(GameState estado) => texto.replaceAll('{nome}', estado.nomeOuPadrao);
}

/// Card "Conexões Invisíveis" de uma mulher real da computação.
class CardMulher {
  final String nome;
  final String periodo;
  final String descricao;
  final String frase;
  final Color cor;

  const CardMulher({
    required this.nome,
    required this.periodo,
    required this.descricao,
    required this.frase,
    required this.cor,
  });

  String get iniciais {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    final primeira = partes.first[0];
    final ultima = partes.length > 1 ? partes.last[0] : '';
    return (primeira + ultima).toUpperCase();
  }
}

/// Textos que ficam no código: cards das mulheres e o atalho da fase 3.
class Historia {
  Historia._();

  // As falas do prólogo, das memórias, do telefonema e do epílogo agora
  // ficam no arquivo do Twine: assets/historia/lumina.twee

  // ---------------- CARDS ----------------

  static const Map<int, CardMulher> cards = {
    1: CardMulher(
      nome: 'Ada Lovelace',
      periodo: '1815–1852',
      descricao:
          'Matemática inglesa. Em 1843, escreveu o que é considerado o primeiro algoritmo publicado: uma sequência de passos para a Máquina Analítica de Charles Babbage, que nem chegou a ser construída.',
      frase: 'Ela programou uma máquina que ainda não existia.',
      cor: Color(0xFF7E57C2),
    ),
    2: CardMulher(
      nome: 'Grace Hopper',
      periodo: '1906–1992',
      descricao:
          'Cientista da computação e almirante da Marinha dos EUA. Criou um dos primeiros compiladores, em 1952, e suas ideias deram origem à linguagem COBOL. Defendia que computadores deviam entender comandos em palavras.',
      frase: 'Ela ensinou as máquinas a entender o que a gente pede.',
      cor: Color(0xFF1E88E5),
    ),
    3: CardMulher(
      nome: 'Cláudia Werner',
      periodo: 'Brasil',
      descricao:
          'Pesquisadora brasileira e professora da COPPE/UFRJ, referência em engenharia de software no país, com pesquisas sobre reutilização de software. Formou gerações de pesquisadoras e pesquisadores.',
      frase: 'Engenharia de software também se escreve em português.',
      cor: Color(0xFF43A047),
    ),
    4: CardMulher(
      nome: 'Margaret Hamilton',
      periodo: '1936–',
      descricao:
          'Liderou a equipe de software do programa Apollo, no MIT. Em 1969, minutos antes do pouso da Apollo 11 na Lua, o computador ficou sobrecarregado; o software dela priorizou as tarefas mais importantes, e o pouso continuou.',
      frase: 'Quando tudo aconteceu ao mesmo tempo, o código dela soube o que importava.',
      cor: Color(0xFFF4511E),
    ),
  };

  /// O 5º card é o da própria jogadora.
  static CardMulher cardDaJogadora(GameState estado) => CardMulher(
        nome: estado.nomeOuPadrao,
        periodo: 'hoje',
        descricao:
            'Restaurou sozinha uma casa inteligente numa noite de tempestade: sequências, comandos, decisões e eventos.',
        frase: 'A próxima da lista.',
        cor: const Color(0xFFE65100),
      );

  // ---------------- ATALHO (fase 3) ----------------

  static const String propostaAtalho =
      'Ou... a gente pode só deixar a luz da varanda ligada direto. Dá menos trabalho, né?';
  static const String reacaoAceitouAtalho =
      'Hmm... de dia, com sol forte, a luz continuaria gastando energia. Acho que eu dei uma péssima ideia. Vamos fazer a casa decidir?';
  static const String reacaoRecusouAtalho =
      'Era um teste! Sua avó dizia: "gambiarra hoje, conta de luz amanhã."';
}
