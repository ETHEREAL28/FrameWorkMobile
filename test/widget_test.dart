import 'package:flutter_test/flutter_test.dart';
import 'package:stayease_uts/main.dart';

void main() {
  testWidgets('StayEase app smoke test', (WidgetTester tester) async {
    // Build app dan trigger frame pertama
    await tester.pumpWidget(const StayEaseApp());

    // Verifikasi app title muncul
    expect(find.text('StayEase'), findsOneWidget);
  });
}
