// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clock/clock_editor.dart';

void main() {
  group("ClockEditor.changeMin", () {
    test("count up", () {
      expect(ClockEditor.changeMin("03", "up"), "04");
    });

    test("count up from 99, to 00", () {
      expect(ClockEditor.changeMin("99", "up"), "00");
    });

    test("count down", () {
      expect(ClockEditor.changeMin("03", "down"), "02");
    });

    test("count down from 00, to 99", () {
      expect(ClockEditor.changeMin("00", "down"), "99");
    });
  });

  group("ClockEditor.changeSec", () {
    test("count up", () {
      expect(ClockEditor.changeSec("03", "up"), "04");
    });

    test("count up from 59, to 00", () {
      expect(ClockEditor.changeSec("59", "up"), "00");
    });

    test("count down", () {
      expect(ClockEditor.changeSec("03", "down"), "02");
    });

    test("count down from 00, to 59", () {
      expect(ClockEditor.changeSec("00", "down"), "59");
    });
  });
}
