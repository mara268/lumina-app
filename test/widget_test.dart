import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_app/main.dart';

void main() {
  testWidgets('Verifica o carregamento da tela inicial do Lúmina', (WidgetTester tester) async {
    // Constrói o aplicativo Lúmina e renderiza o primeiro frame
    await tester.pumpWidget(const LuminaApp());

    // Verifica se o título Lúmina está presente na tela
    expect(find.text('Lúmina'), findsOneWidget);

    // Verifica se o botão de início da jornada está visível
    expect(find.text('INICIAR JORNADA'), findsOneWidget);
  });
}