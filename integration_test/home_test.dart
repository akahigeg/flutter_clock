import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_clock/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("end-to-end test", () {
    testWidgets("toggle START/STOP button", (WidgetTester tester) async {
      app.main();
      // await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      expect(find.text("START"), findsOneWidget);
      expect(find.text("03:"), findsOneWidget);

      // await tester.tap(find.widgetWithText(TextButton, "START"));
      await tester.tap(find.byKey(Key("start_stop")));
      await tester.pump(new Duration(seconds: 1)); // タップした後1秒待つ

      expect(find.text("STOP"), findsOneWidget);
      expect(find.text("02:"), findsOneWidget); // タイマーが動く

      await tester.tap(find.widgetWithText(TextButton, "STOP"));
      await tester.pump(new Duration(seconds: 1)); // タップした後1秒待つ

      expect(find.text("START"), findsOneWidget);
      expect(find.text('STOP'), findsNothing);
    });
  });
}
