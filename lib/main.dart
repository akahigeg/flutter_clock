import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Clock(title: 'Flutter Demo Home Page'),
    );
  }
}

class Clock extends StatefulWidget {
  Clock({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  String _timerId = "timer1";

  int _initialMin = 0; // SharedPreferencesから読む
  int _initialSec = 0; // SharedPreferencesから読む
  int _initialMsec = 1000; // 設定できない値なので固定

  String _min = '00';
  String _sec = '00';
  String _msec = '00';

  var _timer;
  var _startTime;
  bool _isStart = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _restoreTimer();

    super.didChangeDependencies();
  }

  void _initTimer() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_timerId, "01:00:00");
  }

  void _restoreTimer() async {
    var prefs = await SharedPreferences.getInstance();
    var timer = prefs.getString(_timerId) ?? "03:00:00";
    var numbers = timer.toString().split(":");

    setState(() {
      _initialMin = int.parse(numbers[0]);
      _initialSec = int.parse(numbers[1]);
      _min = numbers[0].toString().padLeft(2, '0');
      _sec = numbers[1].toString().padLeft(2, '0');
      _msec = numbers[2].toString().padLeft(2, '0');
    });
  }

  void _countDown(Timer timer) {
    // 開始時間と現在時間の差分から表示内容を求める
    var currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    // 経過した時間
    var pastMsec = currentTimestamp - _startTime.millisecondsSinceEpoch;
    int minusSec = (pastMsec / 1000).ceil();
    int minusMin = (minusSec / 60).ceil();

    // 表示する時間
    int newMsec = ((_initialMsec - pastMsec % 1000) ~/ 10).floor();
    int newSec = ((_initialSec - minusSec) % 60).floor();
    int newMin = (_initialMin - minusMin);
    if (newMin < 0) {
      // _initialMinが0のとき-1になってしまうことへの対処
      newMin = 0;
    }

    setState(() {
      _msec = newMsec.toString().padLeft(2, '0');
      _sec = newSec.toString().padLeft(2, '0');
      _min = newMin.toString().padLeft(2, '0');
    });

    if (_min == '00' && _sec == '00' && _msec == '00') {
      // すべての桁が0になったらタイマー終了
      _finishTimer();
    }
  }

  void _switchTimer() {
    setState(() => _isStart = !_isStart);
    if (_isStart) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    setState(() {
      _startTime = DateTime.now();
      _timer = Timer.periodic(
        Duration(milliseconds: 1),
        _countDown,
      );
    });
  }

  void _stopTimer() {
    setState(() {
      _timer.cancel();
    });
  }

  void _resetTimer() {
    _initTimer(); // 仮実装 SharedPreferencesの動作確認のため

    setState(() {
      _isStart = false;
      _stopTimer();
    });

    _restoreTimer();
  }

  void _finishTimer() {
    _stopTimer();
    // TODO: 音ならしたりとか完了処理を入れる
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Remain time:',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_min:',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  '$_sec:',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  '$_msec',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.only(right: 10.0),
                      color:
                          _isStart ? Colors.redAccent : Colors.lightGreenAccent,
                      child: TextButton(
                          child: Text(_isStart ? 'STOP' : 'START'),
                          onPressed: _switchTimer),
                    ),
                    Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.only(left: 10.0),
                      color: Colors.greenAccent,
                      child: TextButton(
                          child: Text('RESET'), onPressed: _resetTimer),
                    )
                  ],
                )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
