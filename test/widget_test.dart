import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulenguage_app/screens/welcome_screen.dart';

void main() {
  testWidgets('Welcome screen shows logo and buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Verifica que el texto principal aparece
    expect(find.text('Bienvenido a'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Registrarte'), findsOneWidget);

    // Verifica que el logo (Image.network) aparece
    expect(find.byType(Image), findsOneWidget);
  });
}
