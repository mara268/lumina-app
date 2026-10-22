import 'package:flutter/foundation.dart';

/// Resposta da jogadora ao telefonema do Seu Valdir (escolha 1).
enum RespostaTelefonema { euConsigo, toAprendendo, desligou }

/// Janela que a jogadora protegeu primeiro na fase 4 (escolha 3).
enum JanelaProtegida { escritorio, estufa }

/// Estado da jogada atual: nome, energia do gerador, escolhas,
/// memórias recuperadas e métricas para a pesquisa.
///
/// Uso: `GameState.instance.nome`, `GameState.instance.gastarEnergia(5)` etc.
/// Telas que mostram valores que mudam (como a energia) podem escutar com
/// `ListenableBuilder(listenable: GameState.instance, ...)`.
class GameState extends ChangeNotifier {
  GameState._();
  static final GameState instance = GameState._();

  static const int energiaInicial = 60;

  String nome = '';
  String avatar = 'a'; // 'a', 'b' ou 'c' (aparência escolhida pela jogadora)
  int energia = energiaInicial;

  // Escolhas que mudam a história
  RespostaTelefonema? telefonema;
  bool? aceitouAtalho;
  JanelaProtegida? janela;

  // Outras variáveis criadas no Twine com (set: $nome to "valor")
  final Map<String, String> variaveis = {};

  // Memórias recuperadas pela Lumi (números das fases concluídas)
  final Set<int> memorias = {};

  // Métricas anônimas para a pesquisa
  final Map<int, int> errosPorFase = {};
  String respostaAberta = '';

  /// Nome para usar nas falas (com um padrão, caso fique vazio).
  String get nomeOuPadrao => nome.trim().isEmpty ? 'Guardiã' : nome.trim();

  /// Guarda o nome com a primeira letra de cada palavra em maiúscula
  /// ("ana clara" vira "Ana Clara"); o resto fica como a jogadora digitou.
  void definirNome(String valor) {
    nome = valor
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
    notifyListeners();
  }

  void definirAvatar(String valor) {
    avatar = valor;
    notifyListeners();
  }

  void gastarEnergia(int quanto) {
    energia = (energia - quanto).clamp(0, 100);
    notifyListeners();
  }

  void ganharEnergia(int quanto) {
    energia = (energia + quanto).clamp(0, 100);
    notifyListeners();
  }

  void registrarErro(int fase) {
    errosPorFase[fase] = (errosPorFase[fase] ?? 0) + 1;
  }

  void recuperarMemoria(int fase) {
    memorias.add(fase);
    notifyListeners();
  }

  void escolherTelefonema(RespostaTelefonema r) {
    telefonema = r;
    notifyListeners();
  }

  /// Registra a escolha do atalho. O custo de energia (−20) é aplicado
  /// pela reação da Lumi na fase 3.
  void escolherAtalho(bool aceitou) {
    aceitouAtalho = aceitou;
    notifyListeners();
  }

  void escolherJanela(JanelaProtegida j) {
    janela = j;
    notifyListeners();
  }

  /// Valor de uma variável usada nas condições do Twine.
  /// telefonema: euConsigo | toAprendendo | desligou
  /// janela: escritorio | estufa
  /// atalho: sim | nao
  String? valorDaVariavel(String nome) {
    switch (nome) {
      case 'telefonema':
        return telefonema?.name;
      case 'janela':
        return janela?.name;
      case 'atalho':
        final a = aceitouAtalho;
        return a == null ? null : (a ? 'sim' : 'nao');
      case 'nome':
        return this.nome; // o parâmetro também se chama nome
      default:
        return variaveis[nome];
    }
  }

  /// Guarda uma escolha vinda do Twine: (set: $variavel to "valor").
  void definirVariavel(String nome, String valor) {
    switch (nome) {
      case 'telefonema':
        for (final r in RespostaTelefonema.values) {
          if (r.name == valor) telefonema = r;
        }
        break;
      case 'janela':
        for (final j in JanelaProtegida.values) {
          if (j.name == valor) janela = j;
        }
        break;
      case 'atalho':
        aceitouAtalho = valor == 'sim';
        break;
      default:
        variaveis[nome] = valor;
    }
    notifyListeners();
  }

  /// Zera tudo para jogar de novo.
  void reiniciar() {
    nome = '';
    avatar = 'a';
    energia = energiaInicial;
    telefonema = null;
    aceitouAtalho = null;
    janela = null;
    memorias.clear();
    variaveis.clear();
    errosPorFase.clear();
    respostaAberta = '';
    notifyListeners();
  }
}
