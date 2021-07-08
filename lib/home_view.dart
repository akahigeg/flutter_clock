import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import './clock_editor.dart';

class Clock extends StatelessWidget {
  Clock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<TimerModel>(context, listen: false).restore();

    return Scaffold(
      appBar: AppBar(title: Text("Flutter Clock"), actions: <Widget>[]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Remain time:',
            ),
            ClockTip(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TimerModel extends ChangeNotifier {
  String _timerId = "timer1";

  int _initialMin = 0; // SharedPreferencesから読む
  int _initialSec = 0; // SharedPreferencesから読む
  int _initialMsec = 1000; // 設定できない値なので固定

  String _min = '00';
  String _sec = '00';
  String _msec = '00';

  var _timer;
  var _startTime;
  var _lastStopTime;
  var _stoppedMilliseconds = 0; // 中断時間の合計
  bool _isStart = false;
  bool _inEdit = false;

  void restore() async {
    var prefs = await SharedPreferences.getInstance();
    var timer = prefs.getString(_timerId) ?? "03:00:00";
    var numbers = timer.toString().split(":");

    _initialMin = int.parse(numbers[0]);
    _initialSec = int.parse(numbers[1]);
    _min = numbers[0].toString().padLeft(2, '0');
    _sec = numbers[1].toString().padLeft(2, '0');
    _msec = numbers[2].toString().padLeft(2, '0');

    update();

    print("restored");

    notifyListeners();
  }

  void changeMin(newMin) {
    _min = newMin;

    notifyListeners();
  }

  void changeSec(newSec) {
    _sec = newSec;

    notifyListeners();
  }

  void _countDown(Timer timer) {
    // 開始時間と現在時間の差分から表示内容を求める
    var currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    // 経過した時間
    var pastMsec = currentTimestamp - _startTime.millisecondsSinceEpoch - _stoppedMilliseconds;
    int minusSec = (pastMsec / 1000).ceil();
    // タイマーが1:03で1秒経過した時も0:02になってしまう。3秒経過で1:00 4秒経過で0:59になってほしい
    // タイマーが1:13で1秒経過した時も0:12になってしまう。13秒経過で1:00 14秒経過で0:59になってほしい
    int minusMin;
    if (minusSec % 60 > _initialSec) {
      minusMin = (minusSec / 60).ceil();
    } else {
      minusMin = (minusSec / 60).floor();
    }

    // 表示する時間
    int newMsec = ((_initialMsec - pastMsec % 1000) ~/ 10).floor();
    int newSec = ((_initialSec - minusSec) % 60).floor();
    int newMin = (_initialMin - minusMin);

    _msec = newMsec.toString().padLeft(2, '0');
    _sec = newSec.toString().padLeft(2, '0');
    _min = newMin.toString().padLeft(2, '0');

    if (_min == '00' && _sec == '00' && _msec == '00') {
      // すべての桁が0になったらタイマー終了
      finish();
    }

    notifyListeners();
  }

  void startOrStop() {
    _isStart = !_isStart;
    if (_isStart) {
      start();
    } else {
      stop();
    }
  }

  void start() {
    if (_lastStopTime == null) {
      // 新しいタイマーの開始
      _startTime = DateTime.now();
    } else {
      // 中断したタイマーの再開
      _stoppedMilliseconds = (DateTime.now().millisecondsSinceEpoch - _lastStopTime.millisecondsSinceEpoch).toInt() + _stoppedMilliseconds;
      print(_lastStopTime.millisecondsSinceEpoch);
      print(DateTime.now().millisecondsSinceEpoch);
      print(_stoppedMilliseconds);
    }

    _timer = Timer.periodic(
      Duration(milliseconds: 1),
      _countDown,
    );
  }

  void stop() {
    // 中断したタイマーの再開ができるように停めた時間を記録
    _lastStopTime = DateTime.now();
    print(_lastStopTime);
    _timer.cancel(); // _switchTimer以外から_stopTimerを呼び出すとなぜかバグる
  }

  void reset() {
    _isStart = false;
    _lastStopTime = null;
    _stoppedMilliseconds = 0;
    _timer.cancel();

    // _stopTimer();
    restore();
  }

  void finish() {
    _timer.cancel();
    // _stopTimer();
    // _player.play('warn.mp3'); Androidでビルドできないのでk
    // TODO: 完了処理を入れる
  }

  void startEdit() {
    _inEdit = true;
    if (_timer != null) {
      reset();
    }

    notifyListeners();
  }

  void update() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_timerId, "$_min:$_sec:00");
  }

  void finishEdit() {
    update();
    _inEdit = false;
    reset();
  }

  void cancelEdit() {
    _inEdit = false;
    reset();
  }
}

// Stateを末端に追いやるテスト
class ClockTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Column(children: [
        timer._inEdit ? DisplayEdit() : Display(),
        timer._inEdit ? InEditButtons() : StartStopButton(),
      ]);
    });
  }
}

class Display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '${timer._min}:',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            '${timer._sec}:',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            '${timer._msec}',
            style: Theme.of(context).textTheme.headline5,
          ),
          // TODO: msecのサイズ小さく
        ],
      );
    });
  }
}

// TODO: ボタンごとに分割
class StartStopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 50,
                margin: EdgeInsets.only(right: 10.0),
                color: timer._isStart ? Colors.redAccent : Colors.lightGreenAccent,
                // TODO: 00:00:00の場合はSTARTを押せないように
                child: TextButton(child: Text(timer._isStart ? 'STOP' : 'START'), onPressed: timer.startOrStop, key: Key("start_stop")),
              ),
              Container(
                width: 100,
                height: 50,
                margin: EdgeInsets.only(left: 10.0),
                color: Colors.greenAccent,
                child: TextButton(child: Text('RESET'), onPressed: timer.reset),
              ),
              Container(
                width: 100,
                height: 50,
                margin: EdgeInsets.only(left: 10.0),
                color: Colors.greenAccent,
                child: TextButton(child: Text('EDIT'), onPressed: timer.startEdit),
              )
            ],
          ));
    });
  }
}

class DisplayEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            upDownButton(context, "up", "min"),
            Text(
              '${timer._min}',
              style: Theme.of(context).textTheme.headline4,
            ),
            upDownButton(context, "down", "min"),
          ]),
          Text(
            ':',
            style: Theme.of(context).textTheme.headline4,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            upDownButton(context, "up", "sec"),
            Text(
              '${timer._sec}',
              style: Theme.of(context).textTheme.headline4,
            ),
            upDownButton(context, "down", "sec"),
          ]),
        ],
      );
    });
  }

  Widget upDownButton(BuildContext context, String upOrDown, String minOrSec) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return ElevatedButton(
          child: Icon(upOrDown == "up" ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
          onPressed: () {
            if (minOrSec == "min") {
              timer.changeMin(ClockEditor.changeMin(timer._min, upOrDown));
              print(timer._min);
            } else {
              timer.changeSec(ClockEditor.changeSec(timer._sec, upOrDown));
            }
          },
          // TODO: 長押し 以下のコードでなぜか動かない
          onLongPress: () {
            print("longpress");
            if (minOrSec == "min") {
              timer.changeMin(ClockEditor.changeMin(timer._min, upOrDown));
            } else {
              timer.changeSec(ClockEditor.changeSec(timer._sec, upOrDown));
            }
          });
    });
  }
}

class InEditButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 50,
                margin: EdgeInsets.only(left: 10.0),
                color: Colors.greenAccent,
                child: TextButton(child: Text('DONE'), onPressed: timer.finishEdit),
              ),
              Container(
                width: 100,
                height: 50,
                margin: EdgeInsets.only(left: 10.0),
                color: Colors.greenAccent,
                child: TextButton(child: Text('CANCEL'), onPressed: timer.cancelEdit),
              )
            ],
          ));
    });
  }
}
