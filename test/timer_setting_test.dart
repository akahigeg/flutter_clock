// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clock/timer_setting.dart';

void main() {
  group("ClockEditor.changeMin", () {
    test("count up", () {
      expect(TimerSetting.changeMin("03", "up"), "04");
    });

    test("count up from 99, to 00", () {
      expect(TimerSetting.changeMin("99", "up"), "00");
    });

    test("count down", () {
      expect(TimerSetting.changeMin("03", "down"), "02");
    });

    test("count down from 00, to 99", () {
      expect(TimerSetting.changeMin("00", "down"), "99");
    });
  });

  group("ClockEditor.changeSec", () {
    test("count up", () {
      expect(TimerSetting.changeSec("03", "up"), "04");
    });

    test("count up from 59, to 00", () {
      expect(TimerSetting.changeSec("59", "up"), "00");
    });

    test("count down", () {
      expect(TimerSetting.changeSec("03", "down"), "02");
    });

    test("count down from 00, to 59", () {
      expect(TimerSetting.changeSec("00", "down"), "59");
    });
  });
}
