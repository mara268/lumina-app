import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_app/main.dart';

void main() {
  testWidgets('Verifica o carregamento da tela inicial do Lúmina', (WidgetTester tester) async {
    // Constrói o aplicativo Lúmina e renderiza o primeiro frame
    await tester.pumpWidget(const LuminaApp());

    // Verifica se o título da tela inicial está presente
    expect(find.textContaining('A Residência Inteligente'), findsOneWidget);

    // Verifica se o botão para conhecer a mentora está visível
    expect(find.text('CONHECER A MENTORA'), findsOneWidget);
  });
}
