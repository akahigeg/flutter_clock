// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_clock/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());
      expect(find.text('Flutter Clock'), findsOneWidget);
      expect(find.text('Remain time:'), findsOneWidget);
      expect(find.text('START'), findsOneWidget);

      // Verify that our counter starts at 0.
      // expect(find.text('03:'), findsOneWidget);
      // expect(find.text('02:'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.widgetWithText(TextButton, "START"));
      await tester.pump();

      expect(find.text('STOP'), findsOneWidget);

      // Verify that our counter has incremented.
      // expect(find.text('03:'), findsNothing);
      // expect(find.text('02:'), findsOneWidget);
    });
  });
}
