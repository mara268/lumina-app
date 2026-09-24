import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/phase_progress_bar.dart';
import 'phase3_reward_screen.dart';

class Phase3Screen extends StatefulWidget {
  const Phase3Screen({super.key});

  @override
  State<Phase3Screen> createState() => _Phase3ScreenState();
}

class _Phase3ScreenState extends State<Phase3Screen> {
  double _luminosidade = 80.0;
  bool _lampadaLigada = false;
  bool _faseConcluida = false;

  void _verificarCondicao() {
    setState(() {
      if (_luminosidade < 40) {
        _lampadaLigada = true;
        _faseConcluida = true;
      } else {
        _lampadaLigada = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ainda há muita luz! A condição IF (luminosidade < 40%) não foi atingida.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });
  }

  void _avancarFase() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Phase3RewardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 3: Condições (IF/ELSE)'),
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
              const PhaseProgressBar(currentStep: 3, totalSteps: 5),
              const SizedBox(height: 12),
              
              const LumiDialogCard(
                text: '"A automação precisa de inteligência! Use a condição lógica: SE a luz ambiente cair abaixo de 40%, ENTÃO ligue a lâmpada."',
                mood: LumiMood.pensando,
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        _lampadaLigada ? Icons.lightbulb : Icons.lightbulb_outline,
                        size: 64,
                        color: _lampadaLigada ? Colors.amber : Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sensor de Luminosidade: ${_luminosidade.toInt()}%',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: _luminosidade,
                        min: 0,
                        max: 100,
                        divisions: 10,
                        activeColor: Colors.amber,
                        label: '${_luminosidade.toInt()}%',
                        onChanged: _faseConcluida ? null : (value) {
                          setState(() {
                            _luminosidade = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _faseConcluida ? null : _verificarCondicao,
                        icon: const Icon(Icons.memory),
                        label: const Text('PROCESSAR CONDIÇÃO LÓGICA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_faseConcluida)
                ElevatedButton.icon(
                  onPressed: _avancarFase,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('VER RECOMPENSA DA FASE 3'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}