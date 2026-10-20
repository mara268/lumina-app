import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'phase1_screen.dart';

class MeetLumiScreen extends StatefulWidget {
  const MeetLumiScreen({super.key});

  @override
  State<MeetLumiScreen> createState() => _MeetLumiScreenState();
}

class _MeetLumiScreenState extends State<MeetLumiScreen>
    with SingleTickerProviderStateMixin {
  // Faz a Lumi flutuar devagar dentro do círculo e o brilho pulsar.
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  // Retrato da Lumi dentro do círculo
                  AnimatedBuilder(
                    animation: _float,
                    builder: (context, child) {
                      final wave = math.sin(_float.value * 2 * math.pi);
                      final pulse = 0.5 + 0.5 * wave;
                      return Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [Color(0xFFFFF3EC), Color(0xFFFFCCBC)],
                          ),
                          border: Border.all(color: const Color(0xFFE65100), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7FE7FF).withAlpha((60 + 70 * pulse).round()),
                              blurRadius: 18 + 8 * pulse,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Transform.translate(
                            offset: Offset(0, 4 + wave * 4),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/lumi/lumi_retrato.png',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                      semanticLabel: 'Lumi, sua mentora',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Olá! Eu sou a Lumi ✨',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sua guia nesta jornada tecnológica',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(12),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Vou te acompanhar por cada cômodo e sistema inteligente.\n\nVocê vai entender como dados do ambiente se transformam em ações automáticas.\n\nVamos começar?',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF424242),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Phase1Screen(),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(
                  'ENTRAR NA FASE 1',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
