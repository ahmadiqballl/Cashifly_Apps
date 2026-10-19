import 'package:flutter_test/flutter_test.dart';
import 'package:cashifly/main.dart';

void main() {
  testWidgets('Cashifly basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CashiflyApp());
    expect(find.byType(CashiflyApp), findsOneWidget);
  });
}
