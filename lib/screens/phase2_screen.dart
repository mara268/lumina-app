import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import 'phase2_reward_screen.dart';

class Phase2Screen extends StatefulWidget {
  const Phase2Screen({super.key});

  @override
  State<Phase2Screen> createState() => _Phase2ScreenState();
}

class _Phase2ScreenState extends State<Phase2Screen> {
  String? selectedCommand;
  bool isVentilationOn = false;
  String? feedback;

  void executeCommand() {
    if (selectedCommand == null) return;
    setState(() {
      if (selectedCommand == 'COMANDO_LIGAR_VENTILADOR') {
        isVentilationOn = true;
        feedback =
            'Sucesso! O comando de escrita foi transmitido e o ventilador resfriou o ambiente.';
      } else {
        isVentilationOn = false;
        feedback =
            'Instrução incorreta. Queremos diminuir a temperatura da sala. Tente outro comando!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fase 2: Primeiras Conexões',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LumiDialogCard(
                text:
                    'Os sensores detectaram calor na sala! Precisamos enviar uma instrução precisa de comando para acionar a ventilação.',
              ),
              const SizedBox(height: 20),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: isVentilationOn
                      ? const Color(0xFFE1F5FE)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isVentilationOn
                        ? Colors.blue.shade300
                        : Colors.orange.shade200,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isVentilationOn
                          ? Icons.air_rounded
                          : Icons.mode_fan_off_rounded,
                      size: 55,
                      color: isVentilationOn
                          ? Colors.blue.shade700
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isVentilationOn
                          ? 'Ventilação: ATIVADA (22°C) ❄️'
                          : 'Ventilação: DESLIGADA (31°C) ☀️',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isVentilationOn
                            ? Colors.blue.shade900
                            : Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Selecione a instrução adequada:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 10),
              RadioListTile<String>(
                title: const Text('Comando: Ligar Sistema de Ventilação'),
                subtitle: const Text('Causa: Ativa o motor do atuador'),
                value: 'COMANDO_LIGAR_VENTILADOR',
                groupValue: selectedCommand,
                activeColor: const Color(0xFFE65100),
                onChanged: (val) => setState(() => selectedCommand = val),
              ),
              RadioListTile<String>(
                title: const Text('Comando: Trancar Fechadura da Porta'),
                subtitle: const Text('Causa: Bloqueia a trava eletrônica'),
                value: 'COMANDO_TRANCA_PORTA',
                groupValue: selectedCommand,
                activeColor: const Color(0xFFE65100),
                onChanged: (val) => setState(() => selectedCommand = val),
              ),
              const SizedBox(height: 14),
              if (!isVentilationOn)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: executeCommand,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text(
                    'ENVIAR INSTRUÇÃO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isVentilationOn
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isVentilationOn
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        feedback!,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isVentilationOn
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                          height: 1.4,
                        ),
                      ),
                      if (isVentilationOn) ...[
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Phase2RewardScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text(
                            'VER RECOMPENSA DA FASE 2 🏆',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}