import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import 'phase1_reward_screen.dart';

class Phase1Screen extends StatefulWidget {
  const Phase1Screen({super.key});

  @override
  State<Phase1Screen> createState() => _Phase1ScreenState();
}

class _Phase1ScreenState extends State<Phase1Screen> {
  final List<String> correctSequence = [
    'Ler Sensor de Presença',
    'Processar Decisão na Placa',
    'Ligar Lâmpada do Corredor',
  ];

  late List<String> userSequence;
  String? feedback;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    userSequence = [
      'Ligar Lâmpada do Corredor',
      'Ler Sensor de Presença',
      'Processar Decisão na Placa',
    ];
  }

  void checkOrder() {
    bool correct = true;
    for (int i = 0; i < correctSequence.length; i++) {
      if (userSequence[i] != correctSequence[i]) {
        correct = false;
        break;
      }
    }

    setState(() {
      isSuccess = correct;
      if (correct) {
        feedback = 'Incrível! A lógica sequencial correta foi estabelecida: Entrada -> Processamento -> Saída!';
      } else {
        feedback = 'A sequência ainda não está ordenada. O sistema precisa primeiro ler o dado, processar e depois acionar!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 1: Sequência Lógica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                text: 'Na computação e automação, a ordem dos passos importa muito! Arraste as instruções para colocar o fluxo na ordem certa.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Ordene o ciclo: Entrada ➔ Processamento ➔ Saída',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
              ),
              const SizedBox(height: 12),
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = userSequence.removeAt(oldIndex);
                    userSequence.insert(newIndex, item);
                    feedback = null;
                  });
                },
                children: [
                  for (int i = 0; i < userSequence.length; i++)
                    Container(
                      key: ValueKey(userSequence[i]),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(8),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(0xFFFFCCBC),
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE65100)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              userSequence[i],
                              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Color(0xFF2D3142)),
                            ),
                          ),
                          const Icon(Icons.drag_handle_rounded, color: Colors.grey),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: checkOrder,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('TESTAR SEQUÊNCIA', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              if (feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSuccess ? Colors.green.shade300 : Colors.red.shade300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        feedback!,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isSuccess ? Colors.green.shade900 : Colors.red.shade900,
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Phase1RewardScreen()),
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text(
                            'VER RECOMPENSA DA FASE 1 🏆',
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