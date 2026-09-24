import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/phase_progress_bar.dart';
import 'phase4_reward_screen.dart';

class Phase4Screen extends StatefulWidget {
  const Phase4Screen({super.key});

  @override
  State<Phase4Screen> createState() => _Phase4ScreenState();
}

class _Phase4ScreenState extends State<Phase4Screen> {
  bool _estaChovendo = false;
  bool _janelasFechadas = false;

  void _simularChuva(bool valor) {
    setState(() {
      _estaChovendo = valor;
      if (_estaChovendo) {
        _janelasFechadas = true; // Evento aciona imediatamente a ação
      }
    });
  }

  void _avancarFase() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Phase4RewardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 4: Eventos em Tempo Real'),
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
              const PhaseProgressBar(currentStep: 4, totalSteps: 5),
              const SizedBox(height: 12),
              
              const LumiDialogCard(
                text: '"Diferente de uma verificação manual, um EVENTO ocorre de surpresa! Simule uma chuva e veja o sistema reagir sozinho."',
                mood: LumiMood.alerta,
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(
                                _estaChovendo ? Icons.water_drop : Icons.wb_sunny,
                                size: 48,
                                color: _estaChovendo ? Colors.blue : Colors.orange,
                              ),
                              const SizedBox(height: 8),
                              const Text('Ambiente', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                _janelasFechadas ? Icons.window : Icons.grid_view,
                                size: 48,
                                color: _janelasFechadas ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              const Text('Atuador (Janela)', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SwitchListTile(
                        title: const Text(
                          'Simular Evento: COMEÇOU A CHOVER',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Altera o estado do sensor externo'),
                        value: _estaChovendo,
                        activeColor: Colors.blue,
                        onChanged: _janelasFechadas ? null : _simularChuva,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_janelasFechadas)
                ElevatedButton.icon(
                  onPressed: _avancarFase,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('VER RECOMPENSA DA FASE 4'),
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