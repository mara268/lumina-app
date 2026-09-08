import 'package:flutter/material.dart';

void main() {
  runApp(const LuminaApp());
}

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lúmina: Conexões Invisíveis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8A65),
          primary: const Color(0xFFE65100),
          surface: const Color(0xFFFFFBF8),
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

// ==========================================
// 1. TELA INICIAL
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE0D2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8A65).withOpacity(0.25),
                          blurRadius: 25,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 75,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.home_work_rounded,
                          size: 60,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Lúmina',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'CONEXÕES INVISÍVEIS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.0,
                      color: Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '“Uma jornada de descoberta pela automação e lógica de programação.”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntroScreen(),
                    ),
                  );
                },
                child: const Text(
                  'INICIAR JORNADA',
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

// ==========================================
// 2. TELA DE INTRODUÇÃO
// ==========================================
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'A Residência Inteligente 🏡',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Você acabou de chegar a uma residência repleta de sensores, atuadores e circuitos automatizados.\n\nPara fazer tudo funcionar em harmonia, você precisará entender a lógica por trás de cada sistema.',
                      style: TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF424242)),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
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
                      builder: (context) => const MeetLumiScreen(),
                    ),
                  );
                },
                child: const Text(
                  'CONHECER A MENTORA',
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

// ==========================================
// 3. CONHEÇA A LUMI
// ==========================================
class MeetLumiScreen extends StatelessWidget {
  const MeetLumiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE0D2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8A65).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, size: 50, color: Color(0xFFE65100)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Lumi — Sua Mentora ✨',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      '“Olá! Eu sou a Lumi ✨\n\nVou te acompanhar em cada cômodo dessa casa. Lembre-se: errar faz parte da descoberta. Nosso primeiro passo é entender como organizar as ações na ordem correta.”',
                      style: TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF424242)),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
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
                      builder: (context) => const MissionSequenceScreen(),
                    ),
                  );
                },
                child: const Text(
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

// ==========================================
// 4. FASE 1: SEQUÊNCIA LÓGICA
// ==========================================
class MissionSequenceScreen extends StatefulWidget {
  const MissionSequenceScreen({super.key});

  @override
  State<MissionSequenceScreen> createState() => _MissionSequenceScreenState();
}

class _MissionSequenceScreenState extends State<MissionSequenceScreen> {
  final List<String> steps = [
    '3. Ligar as lâmpadas da sala',
    '1. Verificar se a energia principal está ativa',
    '2. Conectar a central de comando ao circuito',
  ];

  final List<String> correctOrder = [
    '1. Verificar se a energia principal está ativa',
    '2. Conectar a central de comando ao circuito',
    '3. Ligar as lâmpadas da sala',
  ];

  String? feedbackMessage;
  bool isSuccess = false;

  void checkSequence() {
    bool correct = true;
    for (int i = 0; i < steps.length; i++) {
      if (steps[i] != correctOrder[i]) {
        correct = false;
        break;
      }
    }

    setState(() {
      if (correct) {
        isSuccess = true;
        feedbackMessage =
            'Excelente! Você organizou a sequência lógica correta. A energia flui de forma segura pela sala!';
      } else {
        isSuccess = false;
        feedbackMessage =
            'A ordem ainda não está adequada. Pense: o que precisa ser verificado antes de acionar as lâmpadas? Tente reordenar!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 1: A Descoberta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD1C1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFF8A65),
                      radius: 18,
                      child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '“Para a sala acender sem sobrecarga, precisamos executar as etapas na ordem exata. Arraste os blocos para organizar a sequência lógica.”',
                        style: TextStyle(fontSize: 13.5, height: 1.4, color: Color(0xFF2D3142)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                '🧩 Reorganize a sequência de inicialização:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
              ),
              const SizedBox(height: 10),

              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final String item = steps.removeAt(oldIndex);
                    steps.insert(newIndex, item);
                  });
                },
                children: [
                  for (int index = 0; index < steps.length; index++)
                    Card(
                      key: ValueKey(steps[index]),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1.5,
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.drag_indicator_rounded, color: Color(0xFFE65100)),
                        title: Text(
                          steps[index],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              if (!isSuccess)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: checkSequence,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('CONFIRMAR SEQUÊNCIA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),

              if (feedbackMessage != null) ...[
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
                      Row(
                        children: [
                          Icon(
                            isSuccess ? Icons.celebration_rounded : Icons.info_outline_rounded,
                            color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isSuccess ? 'Sequência Correta!' : 'Quase lá!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        feedbackMessage!,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RewardPhaseOneScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text(
                            'VER RECOMPENSA & CONQUISTA 🏆',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. RECOMPENSA FASE 1
// ==========================================
class RewardPhaseOneScreen extends StatelessWidget {
  const RewardPhaseOneScreen({super.key});

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
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.military_tech_rounded, size: 65, color: Colors.amber),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Conquista Desbloqueada!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '🏅 Mestra da Sequência Lógica',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE65100)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Você aprendeu que os sistemas de automação executam instruções em passos sequenciais e ordenados.\n\nAgora você está pronta para enviar seus primeiros comandos diretos!',
                      style: TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF424242)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
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
                      builder: (context) => const MissionCommandsScreen(),
                    ),
                  );
                },
                child: const Text('AVANÇAR PARA A FASE 2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. FASE 2: COMANDOS & CAUSA/EFEITO
// ==========================================
class MissionCommandsScreen extends StatefulWidget {
  const MissionCommandsScreen({super.key});

  @override
  State<MissionCommandsScreen> createState() => _MissionCommandsScreenState();
}

class _MissionCommandsScreenState extends State<MissionCommandsScreen> {
  String? selectedCommand;
  bool isVentilationOn = false;
  String? feedback;

  void executeCommand() {
    if (selectedCommand == null) return;

    setState(() {
      if (selectedCommand == 'COMANDO_LIGAR_VENTILADOR') {
        isVentilationOn = true;
        feedback = 'Sucesso! O comando de escrita foi transmitido e o ventilador começou a girar, resfriando o ambiente da casa.';
      } else {
        isVentilationOn = false;
        feedback = 'Instrução incorreta para essa necessidade. Queremos diminuir a temperatura da sala. Tente outro comando!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 2: Primeiras Conexões', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD1C1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFF8A65),
                      radius: 18,
                      child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '“Os sensores detectaram que a sala está muito quente! Precisamos enviar uma instrução precisa de comando para acionar a ventilação.”',
                        style: TextStyle(fontSize: 13.5, height: 1.4, color: Color(0xFF2D3142)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: isVentilationOn ? const Color(0xFFE1F5FE) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isVentilationOn ? Colors.blue.shade300 : Colors.orange.shade200, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isVentilationOn ? Icons.air_rounded : Icons.mode_fan_off_rounded,
                      size: 55,
                      color: isVentilationOn ? Colors.blue.shade700 : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isVentilationOn ? 'Ventilação: ATIVADA (22°C) ❄️' : 'Ventilação: DESLIGADA (31°C) ☀️',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isVentilationOn ? Colors.blue.shade900 : Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Selecione a instrução adequada:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: executeCommand,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('ENVIAR INSTRUÇÃO', style: TextStyle(fontWeight: FontWeight.bold)),
                ),

              if (feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isVentilationOn ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isVentilationOn ? Colors.green.shade300 : Colors.red.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        feedback!,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isVentilationOn ? Colors.green.shade900 : Colors.red.shade900,
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RewardPhaseTwoScreen(),
                              ),
                            );
                          },
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 7. RECOMPENSA FASE 2
// ==========================================
class RewardPhaseTwoScreen extends StatelessWidget {
  const RewardPhaseTwoScreen({super.key});

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
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.bolt_rounded, size: 65, color: Colors.blue),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Conquista Desbloqueada!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '⚡ Guardiã dos Comandos & Causa/Efeito',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE65100)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Você compreendeu como uma instrução direta atua sobre os componentes da casa.\n\nAgora vamos aprender a tomar decisões baseadas em CONDIÇÕES (Se... Então)!',
                      style: TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF424242)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
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
                      builder: (context) => const MissionConditionsScreen(),
                    ),
                  );
                },
                child: const Text('AVANÇAR PARA A FASE 3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 8. FASE 3: ESCOLHAS E CONDIÇÕES ("SE... ENTÃO")
// ==========================================
class MissionConditionsScreen extends StatefulWidget {
  const MissionConditionsScreen({super.key});

  @override
  State<MissionConditionsScreen> createState() => _MissionConditionsScreenState();
}

class _MissionConditionsScreenState extends State<MissionConditionsScreen> {
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
        feedback = 'Perfeito! A regra condicional funcionou: SE estiver escuro, ENTÃO a iluminação do jardim é ativada!';
      } else if (selectedCondition == 'CLARO' && selectedAction == 'LIGAR_LUZ') {
        isGardenLightOn = true;
        isSuccess = false;
        feedback = 'Atenção ao desperdício: o sensor indica que o dia está CLARO. As luzes não devem acender sob sol forte.';
      } else {
        isGardenLightOn = false;
        isSuccess = false;
        feedback = 'A condição não foi satisfeita. Tente configurar o sensor para a noite e definir a ação correspondente.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 3: Escolhas & Condições', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD1C1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFF8A65),
                      radius: 18,
                      child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '“Máquinas inteligentes não ligam tudo de uma vez: elas testam condições! Ajude a criar a regra condicional: SE estiver escuro, ENTÃO ligar a luz.”',
                        style: TextStyle(fontSize: 13.5, height: 1.4, color: Color(0xFF2D3142)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 140,
                decoration: BoxDecoration(
                  color: selectedCondition == 'ESCURO' ? const Color(0xFF263238) : const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isGardenLightOn ? Colors.amber : Colors.grey.shade400, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isGardenLightOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                      size: 55,
                      color: isGardenLightOn ? Colors.amberAccent : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ambiente: ${selectedCondition == "ESCURO" ? "Noite (Escuro) 🌙" : "Dia (Claro) ☀️"} | Luz: ${isGardenLightOn ? "ACESO" : "APAGADO"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedCondition == 'ESCURO' ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('1. Escolha o estado do Sensor (Luminosidade):',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'CLARO', label: Text('Dia (Claro) ☀️')),
                  ButtonSegment(value: 'ESCURO', label: Text('Noite (Escuro) 🌙')),
                ],
                selected: {selectedCondition},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedCondition = newSelection.first;
                    isGardenLightOn = false;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Text('2. Defina a Ação Condicional (ENTÃO...):',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: evaluateCondition,
                icon: const Icon(Icons.rule_rounded),
                label: const Text('VALIDAR REGRA CONDICIONAL', style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              if (feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSuccess ? Colors.green.shade300 : Colors.red.shade300),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RewardPhaseThreeScreen(),
                              ),
                            );
                          },
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 9. RECOMPENSA FASE 3
// ==========================================
class RewardPhaseThreeScreen extends StatelessWidget {
  const RewardPhaseThreeScreen({super.key});

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
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.psychology_rounded, size: 65, color: Colors.amber),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Conquista Desbloqueada!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '🌟 Mestra das Decisões Condicionais',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE65100)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Você aprendeu como as máquinas avaliam situações do mundo real usando "SE... ENTÃO"!\n\nAgora vamos entender como o sistema reage automaticamente a EVENTOS inesperados.',
                      style: TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF424242)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
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
                      builder: (context) => const MissionEventsScreen(),
                    ),
                  );
                },
                child: const Text('AVANÇAR PARA A FASE 4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 10. FASE 4: SISTEMAS EM AÇÃO (EVENTOS & RESPOSTAS)
// ==========================================
class MissionEventsScreen extends StatefulWidget {
  const MissionEventsScreen({super.key});

  @override
  State<MissionEventsScreen> createState() => _MissionEventsScreenState();
}

class _MissionEventsScreenState extends State<MissionEventsScreen> {
  bool rainDetected = false;
  String? selectedHandler;
  bool isWindowClosed = false;
  String? feedback;
  bool isSuccess = false;

  void triggerRainEvent() {
    setState(() {
      rainDetected = true;
      feedback = null;
      isSuccess = false;
    });
  }

  void validateResponse() {
    if (selectedHandler == null) return;

    setState(() {
      if (rainDetected && selectedHandler == 'FECHAR_JANELA') {
        isWindowClosed = true;
        isSuccess = true;
        feedback = 'Resposta de Evento Perfeita! O sensor detectou a chuva e acionou imediatamente o servo motor para fechar a janela antes de molhar a casa!';
      } else {
        isSuccess = false;
        feedback = 'Essa ação não protege a residência do evento de chuva. Qual resposta evita que a água entre?';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase 4: Sistemas em Ação', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD1C1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFF8A65),
                      radius: 18,
                      child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '“Um EVENTO é algo que acontece de repente no ambiente. O sistema precisa ter uma resposta pronta programada para quando o evento disparar!”',
                        style: TextStyle(fontSize: 13.5, height: 1.4, color: Color(0xFF2D3142)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Visual da Janela Inteligente / Chuva
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: rainDetected ? const Color(0xFFE0F2F1) : const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: rainDetected ? Colors.teal.shade300 : Colors.green.shade200, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      rainDetected
                          ? (isWindowClosed ? Icons.cloud_outlined : Icons.thunderstorm_rounded)
                          : Icons.wb_sunny_rounded,
                      size: 55,
                      color: rainDetected ? Colors.teal.shade700 : Colors.amber.shade700,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rainDetected
                          ? (isWindowClosed ? 'Janela: PROTEGIDA (Fechada) 🛡️' : 'ALERTA: Chuva Detectada! Janela ABERTA 🌧️')
                          : 'Ambiente Estável: Tempo Limpo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: rainDetected ? (isWindowClosed ? Colors.teal.shade900 : Colors.red.shade900) : Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (!rainDetected)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: triggerRainEvent,
                  icon: const Icon(Icons.water_drop_rounded),
                  label: const Text('SIMULAR DISPARO DO EVENTO (Chuva)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),

              if (rainDetected) ...[
                const Text('Selecione a resposta que o sistema deve disparar:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  title: const Text('Resposta: Fechar Janela Imediatamente'),
                  subtitle: const Text('Ativa o atuador da janela'),
                  value: 'FECHAR_JANELA',
                  groupValue: selectedHandler,
                  activeColor: const Color(0xFFE65100),
                  onChanged: (val) => setState(() => selectedHandler = val),
                ),
                RadioListTile<String>(
                  title: const Text('Resposta: Ligar Aquecedor de Toalhas'),
                  subtitle: const Text('Ativa a resistência elétrica'),
                  value: 'LIGAR_AQUECEDOR',
                  groupValue: selectedHandler,
                  activeColor: const Color(0xFFE65100),
                  onChanged: (val) => setState(() => selectedHandler = val),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: validateResponse,
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text('EXECUTAR RESPOSTA AO EVENTO', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],

              if (feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSuccess ? Colors.green.shade300 : Colors.red.shade300),
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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🎉 Fase 4 Concluída! Pronta para o Desafio Final da Casa Inteligente!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text(
                            'CONCLUIR FASE 4 🏆',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}