class ClockEditor {
  static String changeMin(String min, String upOrDown) {
    int newMin;
    if (upOrDown == 'up') {
      newMin = int.parse(min) + 1;
    } else {
      newMin = int.parse(min) - 1;
    }
    if (newMin == 100) {
      newMin = 0;
    }
    if (newMin == -1) {
      newMin = 99;
    }
    return newMin.toString().padLeft(2, '0');
  }

  static String changeSec(String sec, String upOrDown) {
    int newSec;
    if (upOrDown == 'up') {
      newSec = int.parse(sec) + 1;
    } else {
      newSec = int.parse(sec) - 1;
    }
    if (newSec == 60) {
      newSec = 0;
    }
    if (newSec == -1) {
      newSec = 59;
    }
    return newSec.toString().padLeft(2, '0');
  }
}
