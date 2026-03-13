import 'package:flutter_test/flutter_test.dart';
import 'package:cyberspryt/main.dart';
import 'package:provider/provider.dart';
import 'package:cyberspryt/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Disable animations for the test to avoid pending timers
    // However, Mascot uses its own controllers.

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: const CyberSprytApp(),
      ),
    );

    expect(find.byType(CyberSprytApp), findsOneWidget);

    // Just a few frames
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  });
}
