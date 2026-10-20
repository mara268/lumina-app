import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_app/main.dart';

void main() {
  testWidgets('Verifica o carregamento da tela inicial do Lúmina', (WidgetTester tester) async {
    // Constrói o aplicativo Lúmina e renderiza o primeiro frame
    await tester.pumpWidget(const LuminaApp());

    // Verifica se o título está presente
    expect(find.text('Lúmina'), findsOneWidget);
    expect(find.text('Conexões Invisíveis'), findsOneWidget);

    // Verifica se o botão para começar a história está visível
    expect(find.text('COMEÇAR A HISTÓRIA'), findsOneWidget);
  });
}
