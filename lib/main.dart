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

  String _min = '00';
  String _sec = '00';
  String _msec = '00';

  var _timer;
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
    prefs.setString(_timerId, "99:59:59");
  }

  void _restoreTimer() async {
    var prefs = await SharedPreferences.getInstance();
    var timer = prefs.getString(_timerId) ?? "03:00:00";
    var numbers = timer.toString().split(":");
    print(timer);

    setState(() {
      _min = numbers[0].toString().padLeft(2, '0');
      _sec = numbers[1].toString().padLeft(2, '0');
      _msec = numbers[2].toString().padLeft(2, '0');
    });
  }

  void _countDown(Timer timer) {
    int secDown = 0;
    int newMsec = int.parse(_msec) - 1;
    if (newMsec < 0) {
      newMsec = 59;
      secDown = 1;
    }

    int minDown = 0;
    int newSec = int.parse(_sec) - secDown;
    if (newSec < 0) {
      newSec = 59;
      minDown = 1;
    }

    int newMin = int.parse(_min) - minDown;
    if (newMin < 0) {
      // TODO: minが-1になった時点でタイマー終了
    }
    setState(() {
      _msec = newMsec.toString().padLeft(2, '0');
      _sec = newSec.toString().padLeft(2, '0');
      _min = newMin.toString().padLeft(2, '0');
    });
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
