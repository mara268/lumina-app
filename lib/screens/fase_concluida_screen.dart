import 'package:flutter/material.dart';
import '../widgets/lumi_avatar.dart';
import '../widgets/phase_progress_bar.dart';

/// Tela entre as fases: explica de forma breve como a fase foi resolvida.
///
/// Mostra a Lumi comemorando, o conceito aprendido, o "código" que a
/// jogadora montou, por que ele funciona e um exemplo do dia a dia.
class FaseConcluidaScreen extends StatelessWidget {
  final int numeroFase;
  final String conceito; // ex.: 'Sequência lógica'
  final String comoResolveu; // 1 ou 2 frases
  final String codigo; // o que a jogadora montou
  final String porQueFunciona;
  final String noDiaADia;
  final IconData iconeDiaADia;
  final String textoBotao;
  final WidgetBuilder proximaTela;

  const FaseConcluidaScreen({
    super.key,
    required this.numeroFase,
    required this.conceito,
    required this.comoResolveu,
    required this.codigo,
    required this.porQueFunciona,
    required this.noDiaADia,
    required this.iconeDiaADia,
    required this.textoBotao,
    required this.proximaTela,
  });

  static const Color _laranja = Color(0xFFE65100);

  Widget _secao({required IconData icone, required String titulo, required Widget conteudo}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE0B2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 18, color: _laranja),
              const SizedBox(width: 6),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _laranja,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          conteudo,
        ],
      ),
    );
  }

  static const TextStyle _texto = TextStyle(
    fontSize: 14.5,
    height: 1.5,
    color: Color(0xFF37474F),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PhaseProgressBar(currentStep: numeroFase, totalSteps: 5),
              const SizedBox(height: 8),
              const Center(
                child: LumiAvatar(mood: LumiMood.celebrando, height: 150),
              ),
              const SizedBox(height: 8),
              Text(
                'Fase $numeroFase concluída!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: _laranja.withAlpha(90)),
                  ),
                  child: Text(
                    'Você aprendeu: $conceito',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _laranja,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _secao(
                icone: Icons.check_circle_outline,
                titulo: 'COMO VOCÊ RESOLVEU',
                conteudo: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(comoResolveu, style: _texto),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        codigo,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'monospace',
                          fontSize: 13.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _secao(
                icone: Icons.lightbulb_outline,
                titulo: 'POR QUE FUNCIONA',
                conteudo: Text(porQueFunciona, style: _texto),
              ),
              const SizedBox(height: 12),

              _secao(
                icone: iconeDiaADia,
                titulo: 'NO DIA A DIA',
                conteudo: Text(noDiaADia, style: _texto),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: proximaTela),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  textoBotao,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _laranja,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
