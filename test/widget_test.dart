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
  testWidgets('toggle START and STOP button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());
      expect(find.text('START'), findsOneWidget);

      // STARTボタンをタップ
      // await tester.tap(find.widgetWithText(TextButton, "START"));
      await tester.tap(find.byKey(Key("start_stop")));
      await tester.pump(new Duration(seconds: 1)); // タップした後1秒待つ

      expect(find.text('STOP'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "STOP"));
      await tester.pump(new Duration(seconds: 1)); // タップした後1秒待つ

      expect(find.text('START'), findsOneWidget);

      // 疑似タイマーだが止めておかないと動き続けてエラーがでるようだ？
    });
  });

  testWidgets('Default Timer is 03:00:00', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());

      await tester.pumpAndSettle(); // prefsからの読み込みを待つ

      // タイマー表示 分のところをチェック デフォルトが3分
      expect(find.text('03:'), findsOneWidget);
      expect(find.text('02:'), findsNothing);

      // 秒
      expect(find.text('00:'), findsOneWidget);

      // ミリ秒以下2桁
      expect(find.text('00'), findsOneWidget);

      // Flutterのテストはタイマーが動かないのでタイマーによる変化はテストできない
    });
  });
}
