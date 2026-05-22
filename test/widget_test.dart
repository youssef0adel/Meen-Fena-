import 'package:flutter_test/flutter_test.dart';
import 'package:meen_fena/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MeenFenaApp()); // ✅ MeenFenaApp مش MyApp
    await tester.pumpAndSettle();
  });
}