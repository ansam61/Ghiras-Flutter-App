import 'package:flutter_test/flutter_test.dart';
import 'package:ghiras_app/main.dart';

void main() {
  testWidgets('Ghiras App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const GhirasApp());
    expect(find.byType(GhirasApp), findsOneWidget);
  });
}
