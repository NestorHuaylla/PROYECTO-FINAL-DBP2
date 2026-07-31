import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_final/main.dart';

void main() {
  testWidgets('GESTY Finanzas app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GestyApp());

    // Verify that the header text is present.
    expect(find.text('GESTY Finanzas'), findsOneWidget);
  });
}
