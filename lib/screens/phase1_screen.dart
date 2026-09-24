import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import '../widgets/phase_progress_bar.dart';
import 'phase1_reward_screen.dart';

class Phase1Screen extends StatefulWidget {
  const Phase1Screen({super.key});

  @override
  State<Phase1Screen> createState() => _Phase1ScreenState();
}

class _Phase1ScreenState extends State<Phase1Screen> {
  final List<String> _correctOrder = [
    'Ler Sensor de Presença',
    'Processar Decisão na Placa',
    'Ligar Lâmpada do Corredor',
  ];

  late List<String> _userOrder;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _userOrder = [
      'Ligar Lâmpada do Corredor',
      'Ler Sensor de Presença',
      'Processar Decisão na Placa',
    ];
  }

  void _verifyOrder() {
    bool isCorrect = true;
    for (int i = 0; i < _correctOrder.length; i++) {
      if (_userOrder[i] != _correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Phase1RewardScreen()),
      );
    } else {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ops! A ordem ainda não está certa. Lembre-se: Entrada -> Processamento -> Saída.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 1: Sequência Lógica'),
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
              // 1. AQUI ESTÁ A BARRA DE PROGRESSO QUE CRIÁMOS:
              const PhaseProgressBar(currentStep: 1),
              const SizedBox(height: 12),

              // 2. O card da Lumi logo abaixo:
              const LumiDialogCard(
                text:
                    '"Na computação e automação, a ordem dos passos importa muito! Arraste as instruções para colocar o fluxo na ordem certa."',
              ),
              const SizedBox(height: 20),

              const Text(
                'Ordene o ciclo: Entrada -> Processamento -> Saída',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final String item = _userOrder.removeAt(oldIndex);
                    _userOrder.insert(newIndex, item);
                    _hasError = false;
                  });
                },
                children: [
                  for (int i = 0; i < _userOrder.length; i++)
                    Card(
                      key: ValueKey(_userOrder[i]),
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _hasError ? Colors.red.shade200 : Colors.grey.shade300,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFFCCBC),
                          foregroundColor: const Color(0xFFD84315),
                          child: Text('${i + 1}'),
                        ),
                        title: Text(
                          _userOrder[i],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.drag_handle),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _verifyOrder,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'TESTAR SEQUÊNCIA',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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