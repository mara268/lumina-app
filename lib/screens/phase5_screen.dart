import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import 'final_victory_screen.dart';

class Phase5Screen extends StatefulWidget {
  const Phase5Screen({super.key});

  @override
  State<Phase5Screen> createState() => _Phase5ScreenState();
}

class _Phase5ScreenState extends State<Phase5Screen> {
  bool lightsActivated = false;
  bool windowSecured = false;
  bool ventilationAdjusted = false;
  bool automationDeployed = false;

  void deployFullAutomation() {
    setState(() {
      lightsActivated = true;
      windowSecured = true;
      ventilationAdjusted = true;
      automationDeployed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 5: A Casa Inteligente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LumiDialogCard(text: 'A noite caiu e uma chuva começou! Integre Sequência, Comandos, Condições e Eventos para automatizar toda a casa!'),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: automationDeployed ? const Color(0xFFE8F5E9) : const Color(0xFFECEFF1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: automationDeployed ? Colors.green.shade400 : Colors.blueGrey.shade300, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(automationDeployed ? Icons.verified_rounded : Icons.sensors_rounded, size: 55, color: automationDeployed ? Colors.green.shade700 : Colors.blueGrey.shade700),
                    const SizedBox(height: 10),
                    Text(automationDeployed ? 'SISTEMA TOTALMENTE INTEGRADO ✅' : 'AGUARDANDO PROGRAMAÇÃO INTEGRADA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: automationDeployed ? Colors.green.shade900 : Colors.blueGrey.shade900)),
                    const Divider(height: 24),
                    _buildStatusRow('1. Iluminação (Condicional Noite):', lightsActivated ? 'Ligada' : 'Pendente'),
                    const SizedBox(height: 6),
                    _buildStatusRow('2. Janelas (Evento Chuva):', windowSecured ? 'Protegida' : 'Aberta'),
                    const SizedBox(height: 6),
                    _buildStatusRow('3. Climatização (Comando Escrita):', ventilationAdjusted ? 'Modo Econômico' : 'Standby'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (!automationDeployed)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE65100), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: deployFullAutomation,
                  icon: const Icon(Icons.hub_rounded),
                  label: const Text('EXECUTAR AUTOMAÇÃO COMPLETA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              if (automationDeployed) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green.shade300)),
                  child: const Column(
                    children: [
                      Text('🎉 Conexões Estabelecidas com Sucesso!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1B5E20))),
                      SizedBox(height: 6),
                      Text('Você comandou a residência de ponta a ponta!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5, color: Color(0xFF2E7D32))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FinalVictoryScreen())),
                  icon: const Icon(Icons.emoji_events_rounded),
                  label: const Text('VER CONCLUSÃO DA JORNADA 🏆', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        Text(status, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFE65100))),
      ],
    );
  }
}