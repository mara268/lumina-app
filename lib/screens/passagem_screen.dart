import 'package:flutter/material.dart';

import '../models/game_state.dart';
import '../story/historia.dart';
import '../story/recursos.dart';
import '../story/roteiro.dart';
import '../widgets/cena_dialogo.dart';
import '../widgets/destaques.dart';
import 'card_screen.dart';
import 'final_victory_screen.dart';
import 'phase1_screen.dart';
import 'phase2_screen.dart';
import 'phase3_screen.dart';
import 'phase4_screen.dart';
import 'phase5_screen.dart';

/// Abre uma passagem do Twine (troca a tela atual com um esmaecer suave).
/// Ao entrar num desafio, limpa a pilha de telas (o "voltar" leva ao início).
void irParaPassagem(BuildContext context, String nome) {
  final rota = PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondary) => PassagemScreen(nome: nome),
    transitionsBuilder: (context, animation, secondary, child) =>
        FadeTransition(opacity: animation, child: child),
  );
  final destino = Roteiro.instancia.passagem(nome);
  if (destino != null && destino.tem('desafio')) {
    Navigator.of(context).pushAndRemoveUntil(rota, (r) => r.isFirst);
  } else {
    Navigator.of(context).pushReplacement(rota);
  }
}

/// Mostra uma passagem do Twine conforme as tags dela:
/// - desafio → a fase do app (Fase 1 a 5)
/// - card    → o card da mulher (Card 1 a 5)
/// - final   → a tela final
/// - outras  → cena de diálogo (a tag escolhe o cenário)
class PassagemScreen extends StatefulWidget {
  final String nome;

  const PassagemScreen({super.key, required this.nome});

  @override
  State<PassagemScreen> createState() => _PassagemScreenState();
}

class _PassagemScreenState extends State<PassagemScreen> {
  Passagem? _passagem;
  String _nomeFinal = '';

  @override
  void initState() {
    super.initState();
    final roteiro = Roteiro.instancia;

    // segue os (go-to:) que valem, com limite para evitar voltas infinitas
    var nome = widget.nome;
    var p = roteiro.passagem(nome);
    for (int pulos = 0; p != null && pulos < 10; pulos++) {
      final destino = p.irPara;
      if (destino == null) break;
      nome = destino;
      p = roteiro.passagem(nome);
    }
    _nomeFinal = nome;
    _passagem = p;
    if (p == null) return;

    // executa os (set:) da passagem, na ordem
    for (final item in p.itens) {
      if (item.tipo == TipoItem.variavel && item.vale) {
        GameState.instance.definirVariavel(item.partes[0], item.partes[1]);
      }
    }
    if (p.tem('memoria') && p.numero != null) {
      GameState.instance.recuperarMemoria(p.numero!);
    }
  }

  void _ir(String destino) => irParaPassagem(context, destino);

  /// Ilustração da memória pelo nome da passagem:
  /// "Memoria 1" → assets/images/memorias/memoria_1.png (ou .jpg)
  /// "Memoria 4 Estufa" → memoria_4_estufa.png
  static String? _imagemDaMemoria(String nomePassagem) {
    final base = nomePassagem
        .trim()
        .toLowerCase()
        .replaceAll('ó', 'o')
        .replaceAll(RegExp(r'\s+'), '_');
    for (final ext in ['png', 'jpg']) {
      final caminho = 'assets/images/memorias/$base.$ext';
      if (Recursos.existe(caminho) && Recursos.carregadoComSucesso) return caminho;
    }
    return null;
  }

  static AmbienteCena _ambiente(Passagem p) {
    if (p.tem('entardecer')) return AmbienteCena.entardecer;
    if (p.tem('cozinha')) return AmbienteCena.cozinha;
    if (p.tem('tempestade')) return AmbienteCena.tempestade;
    if (p.tem('escritorio')) return AmbienteCena.escritorio;
    if (p.tem('sala') || p.tem('telefone')) return AmbienteCena.telefone;
    if (p.tem('amanhecer')) return AmbienteCena.amanhecer;
    if (p.tem('memoria')) return AmbienteCena.memoria;
    return AmbienteCena.escritorio;
  }

  Widget _desafio(int? numero) {
    switch (numero) {
      case 1:
        return const Phase1Screen();
      case 2:
        return const Phase2Screen();
      case 3:
        return const Phase3Screen();
      case 4:
        return const Phase4Screen();
      case 5:
        return const Phase5Screen();
      default:
        return _erro('A passagem "${_passagem?.nome}" tem a tag desafio, mas o nome precisa ser "Fase 1" a "Fase 5".');
    }
  }

  Widget _erro(String mensagem) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_note, size: 64, color: Color(0xFFFFCC80)),
              const SizedBox(height: 12),
              const Text(
                'Problema no arquivo do Twine',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                mensagem,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('VOLTAR AO INÍCIO'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cena(Passagem p) {
    final itens = p.itensValidos;
    final falas = <Fala>[];
    final trocasDeElenco = <int, List<Personagem>?>{};
    Widget? destaque;
    int destaqueAPartir = 0;

    for (final item in itens) {
      switch (item.tipo) {
        case TipoItem.fala:
          falas.add(item.fala!);
          break;
        case TipoItem.elenco:
          // "Elenco:" vale a partir da próxima fala (pode trocar no meio da cena).
          // "Elenco: quem fala" mostra só a personagem da fala atual.
          if (item.partes.join(',').trim().toLowerCase() == 'quem fala') {
            trocasDeElenco[falas.length] = null;
            break;
          }
          trocasDeElenco[falas.length] = item.partes
              .map(Roteiro.personagemPorNome)
              .whereType<Personagem>()
              .where((q) => q != Personagem.narrador)
              .toList();
          break;
        case TipoItem.mostrar:
          if (destaque != null || item.partes.isEmpty) break;
          destaqueAPartir = falas.length;
          final tipo = item.partes[0].toLowerCase();
          if (tipo == 'bilhete') {
            final texto = (item.partes.length > 1 ? item.partes.sublist(1).join(' | ') : '')
                .replaceAll('<br>', '\n')
                .replaceAll('{nome}', GameState.instance.nomeOuPadrao);
            destaque = BilheteDestaque(texto: texto);
          } else {
            String parte(int i) => item.partes.length > i ? item.partes[i] : '';
            destaque = FotoAntigaDestaque(
              titulo: parte(1),
              ano: parte(2),
              icone: parte(3),
              rotulo: p.tem('memoria') && p.numero != null ? 'MEMÓRIA ${p.numero} DE 5 RECUPERADA' : null,
              imagem: _imagemDaMemoria(p.nome),
            );
          }
          break;
        case TipoItem.variavel:
        case TipoItem.irPara:
          break;
      }
    }

    if (falas.isEmpty) falas.add(const Fala(Personagem.narrador, '...'));

    final opcoes = [for (final link in p.links) OpcaoCena(link.texto, () => _ir(link.destino))];

    return CenaDialogo(
      key: ValueKey(p.nome),
      falas: falas,
      ambiente: _ambiente(p),
      trocasDeElenco: trocasDeElenco,
      destaque: destaque,
      destaqueAPartirDaFala: destaqueAPartir,
      opcoes: opcoes,
      textoBotaoFinal: 'VOLTAR AO INÍCIO',
      onFim: () => Navigator.of(context).popUntil((r) => r.isFirst),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _passagem;
    if (p == null) {
      return _erro('Não encontrei a passagem "$_nomeFinal". Confira se o nome no botão do Twine é igual ao nome da passagem.');
    }
    if (p.tem('desafio')) return _desafio(p.numero);
    if (p.tem('final')) return const FinalVictoryScreen();
    if (p.tem('card')) {
      final link = p.links.isEmpty ? null : p.links.first;
      return CardScreen(
        numero: p.numero ?? 5,
        textoBotao: link?.texto ?? 'CONTINUAR',
        aoContinuar: () => link == null ? Navigator.of(context).popUntil((r) => r.isFirst) : _ir(link.destino),
      );
    }
    return _cena(p);
  }
}
