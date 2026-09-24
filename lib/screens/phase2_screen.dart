import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/phase_progress_bar.dart';
import 'phase2_reward_screen.dart';

class Phase2Screen extends StatefulWidget {
  const Phase2Screen({super.key});

  @override
  State<Phase2Screen> createState() => _Phase2ScreenState();
}

class _Phase2ScreenState extends State<Phase2Screen> {
  bool _comandoEnviado = false;

  void _enviarComando() {
    setState(() {
      _comandoEnviado = true;
    });
  }

  void _avancarFase() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Phase2RewardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 2: Comandos & Instruções'),
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
              const PhaseProgressBar(currentStep: 2, totalSteps: 5),
              const SizedBox(height: 12),
              
              const LumiDialogCard(
                text: '"Agora que sabemos a ordem, precisamos enviar a instrução correta para o atuador. Envie o comando para ligar a climatização!"',
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
                        _comandoEnviado ? Icons.ac_unit : Icons.mode_fan_off,
                        size: 64,
                        color: _comandoEnviado ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _comandoEnviado ? 'Status: MODO ECONÔMICO ATIVADO' : 'Status: DESLIGADO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _comandoEnviado ? Colors.blue : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _comandoEnviado ? null : _enviarComando,
                        icon: const Icon(Icons.send),
                        label: const Text('ENVIAR COMANDO (0x01)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_comandoEnviado)
                ElevatedButton.icon(
                  onPressed: _avancarFase,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('VER RECOMPENSA DA FASE 2'),
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