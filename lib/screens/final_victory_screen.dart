import 'package:flutter/material.dart';
import '../widgets/iot_monitor_panel.dart';

class FinalVictoryScreen extends StatelessWidget {
  const FinalVictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Fundo escuro para destacar a vitória
      appBar: AppBar(
        title: const Text('Missão Cumprida'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 100),
              const SizedBox(height: 24),
              const Text(
                'PARABÉNS!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Você dominou a abordagem STEAM e conectou todos os dispositivos da casa. As "Conexões Invisíveis" da Internet das Coisas estão agora nas suas mãos!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // O log final mostrando o resumo da jornada da aluna
              const IotMonitorPanel(
                logs: [
                  'Inicializando diagnóstico geral do sistema...',
                  '[Fase 1] Sequência de LEDs -> OK',
                  '[Fase 2] Comando Atuador -> OK',
                  '[Fase 3] Lógica Condicional -> OK',
                  '[Fase 4] Eventos em Tempo Real -> OK',
                  '[Fase 5] Integração Casa Inteligente -> ONLINE',
                  '',
                  '>>> STATUS: SISTEMA 100% OPERACIONAL. <<<',
                  'Aguardando novas instruções...'
                ],
              ),
              
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // Volta para o ecrã inicial da aplicação
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text(
                  'VOLTAR AO INÍCIO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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