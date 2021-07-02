import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import './edit_view.dart';

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
  bool _inEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _restoreTimer();

    super.didChangeDependencies();
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

    _updateTimer();
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

  void _changeMin(String upOrDown) {
    int newMin;
    if (upOrDown == 'up') {
      newMin = int.parse(_min) + 1;
    } else {
      newMin = int.parse(_min) - 1;
    }
    setState(() {
      _min = newMin.toString().padLeft(2, '0');
    });
  }
  // TODO: 上限と下限の制限を入れる
  // secのアップデート
  // msecは編集画面からは消す

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditView(title: 'Edit')));
            })
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Remain time:',
            ),
            _inEdit ? displayEdit(context) : displayTimer(context),
            _inEdit ? inEditButtons() : buttons(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget displayTimer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
        // TODO: msecのサイズ小さく
      ],
    );
  }

  Widget displayEdit(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              child: Icon(Icons.arrow_drop_up),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              onPressed: () {
                _changeMin("up");
              }),
          Text(
            '$_min',
            style: Theme.of(context).textTheme.headline4,
          ),
          ElevatedButton(
              child: Icon(Icons.arrow_drop_down),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              onPressed: () {
                _changeMin("down");
              }),
        ]),
        Text(
          ':',
          style: Theme.of(context).textTheme.headline4,
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.arrow_drop_up),
          Text(
            '$_sec',
            style: Theme.of(context).textTheme.headline4,
          ),
          Icon(Icons.arrow_drop_down),
        ]),
        Text(
          ':',
          style: Theme.of(context).textTheme.headline4,
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.arrow_drop_up),
          Text(
            '$_msec',
            style: Theme.of(context).textTheme.headline4,
          ),
          Icon(Icons.arrow_drop_down),
        ]),
      ],
    );
  }

  Widget buttons() {
    return Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 50,
              margin: EdgeInsets.only(right: 10.0),
              color: _isStart ? Colors.redAccent : Colors.lightGreenAccent,
              child: TextButton(child: Text(_isStart ? 'STOP' : 'START'), onPressed: _switchTimer),
            ),
            Container(
              width: 100,
              height: 50,
              margin: EdgeInsets.only(left: 10.0),
              color: Colors.greenAccent,
              child: TextButton(child: Text('RESET'), onPressed: _resetTimer),
            ),
            Container(
              width: 100,
              height: 50,
              margin: EdgeInsets.only(left: 10.0),
              color: Colors.greenAccent,
              child: TextButton(child: Text('EDIT'), onPressed: _startEdit),
            )
          ],
        ));
  }

  Widget inEditButtons() {
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
              child: TextButton(child: Text('DONE'), onPressed: _finishEdit),
            )
          ],
        ));
  }

  void _updateTimer() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_timerId, "$_min:$_sec:$_msec");
  }

  _startEdit() {
    _restoreTimer();
    setState(() {
      _inEdit = true;
    });
  }

  _finishEdit() {
    _updateTimer();
    _restoreTimer();
    setState(() {
      _inEdit = false;
    });
  }
}
