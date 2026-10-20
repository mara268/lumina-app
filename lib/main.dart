import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'story/roteiro.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega a história escrita no Twine (assets/historia/lumina.twee).
  // Se der problema, o app abre mesmo assim e mostra o aviso na hora da cena.
  try {
    await Roteiro.carregar();
  } catch (erro) {
    debugPrint('Não consegui carregar a história do Twine: $erro');
  }

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
