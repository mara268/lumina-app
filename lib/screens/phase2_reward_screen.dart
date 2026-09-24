import 'package:flutter/material.dart';
import '../widgets/iot_monitor_panel.dart';
import 'phase3_screen.dart';

class Phase2RewardScreen extends StatelessWidget {
  const Phase2RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Comando Executado'),
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
              const Icon(Icons.settings_remote, color: Colors.blueAccent, size: 80),
              const SizedBox(height: 24),
              const Text(
                'COMANDO ENVIADO!',
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
                  'Iniciando protocolo de transmissão...',
                  'Alvo: ATUADOR_CLIMATIZACAO',
                  'Enviando pacote (0x01)...',
                  'Aguardando confirmação (ACK)...',
                  '[SUCESSO] Modo Econômico ativado no destino.',
                ],
              ),
              
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Phase3Screen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('AVANÇAR PARA FASE 3'),
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