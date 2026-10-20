import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/lumi_reaction.dart';
import '../widgets/phase_progress_bar.dart';
import 'final_victory_screen.dart';

/// Um bloco da biblioteca da jogadora.
class _Bloco {
  final String id;
  final String conceito;
  final String codigo;
  final String sistema; // parte da casa que o bloco controla (vazio = bloco errado)
  final IconData icone;

  const _Bloco(this.id, this.conceito, this.codigo, this.sistema, this.icone);

  bool get correto => sistema.isNotEmpty;
}

class Phase5Screen extends StatefulWidget {
  const Phase5Screen({super.key});

  @override
  State<Phase5Screen> createState() => _Phase5ScreenState();
}

class _Phase5ScreenState extends State<Phase5Screen> {
  // 4 blocos certos (um de cada fase) + 2 "pegadinhas"
  static const List<_Bloco> _biblioteca = [
    _Bloco('ventilador', 'Comando', 'ENVIAR → ventilador | LIGAR', 'Ventilação', Icons.air),
    _Bloco('chuva_abrir', 'Evento', 'QUANDO chuva FAÇA abrir janelas', '', Icons.water_drop),
    _Bloco('varanda', 'Condição', 'SE luz < 40 ENTÃO ligar varanda SENÃO desligar', 'Varanda', Icons.lightbulb),
    _Bloco('corredor', 'Sequência', 'QUANDO presença no corredor FAÇA acender corredor', 'Corredor', Icons.directions_walk),
    _Bloco('luz_sempre', 'Atalho', 'Deixar todas as luzes sempre ligadas', '', Icons.flash_on),
    _Bloco('chuva_fechar', 'Evento', 'QUANDO chuva FAÇA fechar janelas', 'Janelas', Icons.window),
  ];

  final List<_Bloco> _rotina = [];
  final Set<String> _sistemasLigados = {};
  bool _concluida = false;
  bool _hasError = false;
  String _dicaAtual = '';

  void _alternar(_Bloco bloco) {
    if (_concluida) return;
    setState(() {
      if (_rotina.contains(bloco)) {
        _rotina.remove(bloco);
      } else {
        _rotina.add(bloco);
      }
    });
  }

  Future<void> _executar() async {
    if (_rotina.isEmpty) {
      setState(() {
        _hasError = true;
        _dicaAtual = 'A rotina está vazia! Toque nos blocos da sua biblioteca para colocá-los na Rotina da Noite.';
      });
      return;
    }

    // liga os sistemas dos blocos certos que estão na rotina
    setState(() {
      _sistemasLigados
        ..clear()
        ..addAll(_rotina.where((b) => b.correto).map((b) => b.sistema));
    });

    final pegadinha = _rotina.where((b) => !b.correto).toList();
    final faltando = _biblioteca.where((b) => b.correto && !_rotina.contains(b)).toList();

    if (pegadinha.isEmpty && faltando.isEmpty) {
      setState(() {
        _concluida = true;
        _hasError = false;
      });
      await mostrarReacaoLumi(
        context,
        mood: LumiMood.celebrando,
        titulo: 'A casa despertou!',
        mensagem: 'Sequência, comandos, decisões e eventos funcionando juntos. Lembrei... lembrei de tudo!',
        textoBotao: 'VER A MENSAGEM DA VÓ HELENA',
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FinalVictoryScreen()),
      );
      return;
    }

    final String erro;
    if (pegadinha.isNotEmpty) {
      final b = pegadinha.first;
      erro = b.id == 'chuva_abrir'
          ? 'Opa! Um bloco manda ABRIR as janelas quando chove. A casa ia virar piscina! Tire esse bloco da rotina.'
          : 'O atalho "luzes sempre ligadas" voltou! Isso gasta a energia do gerador. Tire esse bloco da rotina.';
    } else {
      erro = 'Tudo funcionou... menos ${faltando.first.sistema.toLowerCase()}. Qual bloco cuida dessa parte da casa?';
    }

    setState(() {
      _hasError = true;
      _dicaAtual = erro;
    });
    await mostrarReacaoLumi(
      context,
      mood: LumiMood.alerta,
      titulo: 'Quase! Falta um ajuste',
      mensagem: erro,
      textoBotao: 'AJUSTAR A ROTINA',
    );
  }

  Widget _cartaoBloco(_Bloco bloco) {
    final naRotina = _rotina.contains(bloco);
    return Card(
      elevation: naRotina ? 0 : 1,
      color: naRotina ? const Color(0xFFFFF3E0) : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: naRotina ? const Color(0xFFE65100) : Colors.grey.shade300,
          width: naRotina ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: () => _alternar(bloco),
        leading: Icon(bloco.icone, color: const Color(0xFFE65100)),
        title: Text(
          bloco.codigo,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(bloco.conceito),
        trailing: Icon(
          naRotina ? Icons.check_circle : Icons.add_circle_outline,
          color: naRotina ? const Color(0xFFE65100) : Colors.grey,
        ),
      ),
    );
  }

  Widget _status(String sistema, IconData icone) {
    final ligado = _sistemasLigados.contains(sistema);
    return Column(
      children: [
        Icon(icone, size: 34, color: ligado ? Colors.amber.shade700 : Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          sistema,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: ligado ? const Color(0xFF2D3142) : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 5: A Casa Inteligente'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PhaseProgressBar(currentStep: 5, totalSteps: 5),
              const SizedBox(height: 12),

              LumiDialogCard(
                mood: _hasError ? LumiMood.pensando : LumiMood.instruindo,
                text: _hasError
                    ? _dicaAtual
                    : 'Falta uma coisa: a casa não é só uma luz ou uma janela, é tudo funcionando junto. Monte a Rotina da Noite com os blocos que você criou!',
              ),
              const SizedBox(height: 16),

              // painel da casa
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _status('Corredor', Icons.light),
                      _status('Ventilação', Icons.air),
                      _status('Varanda', Icons.lightbulb),
                      _status('Janelas', Icons.window),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Sua biblioteca de blocos (toque para colocar na rotina)',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 6),
              for (final bloco in _biblioteca) _cartaoBloco(bloco),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _concluida ? null : _executar,
                icon: const Icon(Icons.nightlight_round),
                label: Text(
                  'EXECUTAR ROTINA DA NOITE (${_rotina.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
