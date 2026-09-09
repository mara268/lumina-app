import 'package:flutter/material.dart';
import 'phase4_screen.dart';

class Phase3RewardScreen extends StatelessWidget {
  const Phase3RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(color: const Color(0xFFFFF8E1), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 20, spreadRadius: 6)]),
                    child: const Icon(Icons.psychology_rounded, size: 65, color: Colors.amber),
                  ),
                  const SizedBox(height: 24),
                  const Text('Conquista Desbloqueada!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                  const SizedBox(height: 8),
                  const Text('🌟 Mestra das Decisões Condicionais', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE65100))),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))]),
                    child: const Text('Você aprendeu como máquinas avaliam o mundo real usando "SE... ENTÃO"!\n\nAgora vamos entender como reagir automaticamente a EVENTOS.', style: TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF424242)), textAlign: TextAlign.center),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE65100), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Phase4Screen())),
                child: const Text('AVANÇAR PARA A FASE 4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}