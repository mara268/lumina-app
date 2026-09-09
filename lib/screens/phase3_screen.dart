import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import 'phase3_reward_screen.dart';

class Phase3Screen extends StatefulWidget {
  const Phase3Screen({super.key});

  @override
  State<Phase3Screen> createState() => _Phase3ScreenState();
}

class _Phase3ScreenState extends State<Phase3Screen> {
  String selectedCondition = 'CLARO';
  String? selectedAction;
  bool isGardenLightOn = false;
  String? feedback;
  bool isSuccess = false;

  void evaluateCondition() {
    if (selectedAction == null) return;
    setState(() {
      if (selectedCondition == 'ESCURO' && selectedAction == 'LIGAR_LUZ') {
        isGardenLightOn = true;
        isSuccess = true;
        feedback =
            'Perfeito! A regra condicional funcionou: SE estiver escuro, ENTÃO a iluminação é ativada!';
      } else if (selectedCondition == 'CLARO' && selectedAction == 'LIGAR_LUZ') {
        isGardenLightOn = true;
        isSuccess = false;
        feedback =
            'Atenção: o dia está CLARO. As luzes não devem acender sob sol forte.';
      } else {
        isGardenLightOn = false;
        isSuccess = false;
        feedback =
            'Condição não satisfeita. Configure o sensor para Noite e defina a ação correspondente.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fase 3: Escolhas & Condições',
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
                    'Máquinas inteligentes testam condições! Ajude a criar a regra condicional: SE estiver escuro, ENTÃO ligar a luz.',
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 140,
                decoration: BoxDecoration(
                  color: selectedCondition == 'ESCURO'
                      ? const Color(0xFF263238)
                      : const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isGardenLightOn ? Colors.amber : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isGardenLightOn
                          ? Icons.lightbulb_rounded
                          : Icons.lightbulb_outline_rounded,
                      size: 55,
                      color: isGardenLightOn
                          ? Colors.amberAccent
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ambiente: ${selectedCondition == "ESCURO" ? "Noite (Escuro) 🌙" : "Dia (Claro) ☀️"} | Luz: ${isGardenLightOn ? "ACESO" : "APAGADO"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedCondition == 'ESCURO'
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '1. Estado do Sensor (Luminosidade):',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'CLARO', label: Text('Dia ☀️')),
                  ButtonSegment(value: 'ESCURO', label: Text('Noite 🌙')),
                ],
                selected: {selectedCondition},
                onSelectionChanged: (newSelection) => setState(() {
                  selectedCondition = newSelection.first;
                  isGardenLightOn = false;
                }),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Ação Condicional (ENTÃO...):',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                title: const Text('ENTÃO: Ligar Lâmpada do Jardim'),
                value: 'LIGAR_LUZ',
                groupValue: selectedAction,
                activeColor: const Color(0xFFE65100),
                onChanged: (val) => setState(() => selectedAction = val),
              ),
              RadioListTile<String>(
                title: const Text('ENTÃO: Manter Lâmpada Desligada'),
                value: 'DESLIGAR_LUZ',
                groupValue: selectedAction,
                activeColor: const Color(0xFFE65100),
                onChanged: (val) => setState(() => selectedAction = val),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: evaluateCondition,
                icon: const Icon(Icons.rule_rounded),
                label: const Text(
                  'VALIDAR REGRA CONDICIONAL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSuccess
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
                          color: isSuccess
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                          height: 1.4,
                        ),
                      ),
                      if (isSuccess) ...[
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
                              builder: (context) => const Phase3RewardScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text(
                            'VER RECOMPENSA DA FASE 3 🏆',
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