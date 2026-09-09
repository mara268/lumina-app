import 'package:flutter/material.dart';
import '../widgets/lumi_dialog_card.dart';
import 'phase5_screen.dart';

class Phase4Screen extends StatefulWidget {
  const Phase4Screen({super.key});

  @override
  State<Phase4Screen> createState() => _Phase4ScreenState();
}

class _Phase4ScreenState extends State<Phase4Screen> {
  bool rainDetected = false;
  String? selectedHandler;
  bool isWindowClosed = false;
  String? feedback;
  bool isSuccess = false;

  void triggerRainEvent() => setState(() { rainDetected = true; feedback = null; isSuccess = false; });

  void validateResponse() {
    if (selectedHandler == null) return;
    setState(() {
      if (rainDetected && selectedHandler == 'FECHAR_JANELA') {
        isWindowClosed = true;
        isSuccess = true;
        feedback = 'Resposta Perfeita! O sensor detectou a chuva e acionou o motor para fechar a janela antes de molhar a casa!';
      } else {
        isSuccess = false;
        feedback = 'Essa ação não protege a residência do evento de chuva. Tente outra!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fase 4: Sistemas em Ação', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LumiDialogCard(text: 'Um EVENTO é algo que acontece de repente no ambiente. O sistema precisa ter uma resposta pronta programada para quando disparar!'),
              const SizedBox(height: 20),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: rainDetected ? const Color(0xFFE0F2F1) : const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: rainDetected ? Colors.teal.shade300 : Colors.green.shade200, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(rainDetected ? (isWindowClosed ? Icons.shield_rounded : Icons.thunderstorm_rounded) : Icons.wb_sunny_rounded, size: 55, color: rainDetected ? Colors.teal.shade700 : Colors.amber.shade700),
                    const SizedBox(height: 8),
                    Text(rainDetected ? (isWindowClosed ? 'Janela: PROTEGIDA (Fechada) 🛡️' : 'ALERTA: Chuva Detectada! Janela ABERTA 🌧️') : 'Ambiente Estável: Tempo Limpo', style: TextStyle(fontWeight: FontWeight.bold, color: rainDetected ? (isWindowClosed ? Colors.teal.shade900 : Colors.red.shade900) : Colors.green.shade900)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (!rainDetected)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: triggerRainEvent,
                  icon: const Icon(Icons.water_drop_rounded),
                  label: const Text('SIMULAR DISPARO DO EVENTO (Chuva)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              if (rainDetected) ...[
                const Text('Selecione a resposta do sistema:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  title: const Text('Resposta: Fechar Janela Imediatamente'),
                  value: 'FECHAR_JANELA',
                  groupValue: selectedHandler,
                  activeColor: const Color(0xFFE65100),
                  onChanged: (val) => setState(() => selectedHandler = val),
                ),
                RadioListTile<String>(
                  title: const Text('Resposta: Ligar Aquecedor de Toalhas'),
                  value: 'LIGAR_AQUECEDOR',
                  groupValue: selectedHandler,
                  activeColor: const Color(0xFFE65100),
                  onChanged: (val) => setState(() => selectedHandler = val),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE65100), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  onPressed: validateResponse,
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text('EXECUTAR RESPOSTA AO EVENTO', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              if (feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(16), border: Border.all(color: isSuccess ? Colors.green.shade300 : Colors.red.shade300)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(feedback!, style: TextStyle(fontSize: 13.5, color: isSuccess ? Colors.green.shade900 : Colors.red.shade900, height: 1.4)),
                      if (isSuccess) ...[
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 46), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Phase5Screen())),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('AVANÇAR PARA A FASE FINAL 5 🏡', style: TextStyle(fontWeight: FontWeight.bold)),
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