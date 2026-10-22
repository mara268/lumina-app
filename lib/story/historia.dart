import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../widgets/lumi_avatar.dart';

/// Quem está falando numa cena.
enum Personagem { lumi, jogadora, helena, valdir, narrador }

/// Expressão de rosto da jogadora e da vó Helena (escolhe a imagem).
/// trofeu: só a Helena, segurando o troféu no epílogo (helena_trofeu.png).
enum Expressao { neutra, surpresa, feliz, trofeu }

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

  /// Retrato da mulher (opcional). Se o arquivo não existir, o card mostra as iniciais.
  final String? imagem;

  const CardMulher({
    required this.nome,
    required this.periodo,
    required this.descricao,
    required this.frase,
    required this.cor,
    this.imagem,
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
      imagem: 'assets/images/cards/card_1.jpg',
    ),
    2: CardMulher(
      nome: 'Grace Hopper',
      periodo: '1906–1992',
      descricao:
          'Cientista da computação e almirante da Marinha dos EUA. Criou um dos primeiros compiladores, em 1952, e suas ideias deram origem à linguagem COBOL. Defendia que computadores deviam entender comandos em palavras.',
      frase: 'Ela ensinou as máquinas a entender o que a gente pede.',
      cor: Color(0xFF1E88E5),
      imagem: 'assets/images/cards/card_2.jpg',
    ),
    3: CardMulher(
      nome: 'Dorothy Vaughan',
      periodo: '1910–2008',
      descricao:
          'Matemática da NASA. Foi a primeira mulher negra a chefiar uma equipe no centro de pesquisa onde trabalhava. Quando chegaram os computadores eletrônicos, aprendeu sozinha a linguagem FORTRAN e ensinou a sua equipe, para que ninguém ficasse para trás.',
      frase: 'Quando a máquina chegou, ela aprendeu primeiro e ensinou todo mundo.',
      cor: Color(0xFF43A047),
      imagem: 'assets/images/cards/card_3.jpg',
    ),
    4: CardMulher(
      nome: 'Margaret Hamilton',
      periodo: '1936–',
      descricao:
          'Liderou a equipe de software do programa Apollo, no MIT. Em 1969, minutos antes do pouso da Apollo 11 na Lua, o computador ficou sobrecarregado; o software dela priorizou as tarefas mais importantes, e o pouso continuou.',
      frase: 'Quando tudo aconteceu ao mesmo tempo, o código dela soube o que importava.',
      cor: Color(0xFFF4511E),
      imagem: 'assets/images/cards/card_4.jpg',
    ),
  };

  /// O 5º card é o da própria jogadora.
  static CardMulher cardDaJogadora(GameState estado) => CardMulher(
        nome: estado.nomeOuPadrao,
        periodo: '${DateTime.now().year}–',
        descricao:
            'Numa noite de tempestade, acordou a casa da avó com a ajuda da Lumi. Colocou os passos em ordem, enviou comandos, ensinou a casa a decidir sozinha, a reagir à chuva e a seguir uma rotina.',
        frase: 'Toda inventora começa com uma primeira noite. Esta foi a sua.',
        cor: const Color(0xFFE65100),
        imagem: 'assets/images/personagens/retrato_neta_${estado.avatar}_feliz.png',
      );

  // ---------------- ATALHO (fase 3) ----------------

  static const String propostaAtalho =
      'Ou... a gente pode só deixar a luz da varanda ligada direto. Dá menos trabalho, né?';
  static const String reacaoAceitouAtalho =
      'Hmm... de dia, com sol forte, a luz continuaria gastando energia. Acho que eu dei uma péssima ideia. Vamos fazer a casa decidir?';
  static const String reacaoRecusouAtalho =
      'Era um teste! Sua avó dizia: "gambiarra hoje, conta de luz amanhã."';
}