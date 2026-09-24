import 'package:flutter/material.dart';
import '../widgets/iot_monitor_panel.dart';
import 'phase5_screen.dart';

class Phase4RewardScreen extends StatelessWidget {
  const Phase4RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Análise de Dados'),
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
              const Icon(Icons.analytics, color: Colors.blueAccent, size: 80),
              const SizedBox(height: 24),
              const Text(
                'EVENTO CAPTURADO COM SUCESSO!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              
              // Aqui entra o nosso Monitor IoT para a aluna ver o que aconteceu "por trás"!
              const IotMonitorPanel(
                logs: [
                  'Escutando porta 8080...',
                  'EVENTO: sensor_chuva = TRUE',
                  'Gatilho de interrupção acionado!',
                  'Comando: FECHAR_JANELAS_MOD_1',
                  'Atuador confirmou: Janelas fechadas.',
                ],
              ),
              
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Phase5Screen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('AVANÇAR PARA A ÚLTIMA FASE'),
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