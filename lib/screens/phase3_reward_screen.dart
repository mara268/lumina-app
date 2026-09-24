import 'package:flutter/material.dart';
import '../widgets/iot_monitor_panel.dart';
import 'phase4_screen.dart';

class Phase3RewardScreen extends StatelessWidget {
  const Phase3RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Lógica Aprovada'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.memory, color: Colors.blueAccent, size: 80),
              const SizedBox(height: 24),
              const Text(
                'CONDIÇÃO VERDADEIRA!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              
              const IotMonitorPanel(
                logs: [
                  'Solicitando leitura do SENSOR_LUZ...',
                  'Retorno recebido: 38%',
                  'Avaliando bloco condicional IF (38 < 40)...',
                  'Resultado Lógico: TRUE',
                  'Acionando RELÉ_01: HIGH',
                  'Circuito da lâmpada fechado com sucesso.',
                ],
              ),
              
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Phase4Screen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('AVANÇAR PARA FASE 4'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}