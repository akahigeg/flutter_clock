import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class EditView extends StatefulWidget {
  EditView({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  State<StatefulWidget> createState() {
    return _EditViewState();
  }
}

class _EditViewState extends State<EditView> {
  String _timerId = "timer1";

  String _min = '00';
  String _sec = '00';
  String _msec = '00';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _restoreTimer();

    super.didChangeDependencies();
  }

  void _updateTimer() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_timerId, "$_min:$_sec:$_msec");
  }

  void _restoreTimer() async {
    var prefs = await SharedPreferences.getInstance();
    var timer = prefs.getString(_timerId) ?? "03:00:00";
    var numbers = timer.toString().split(":");

    setState(() {
      _min = numbers[0].toString().padLeft(2, '0');
      _sec = numbers[1].toString().padLeft(2, '0');
      _msec = numbers[2].toString().padLeft(2, '0');
    });
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Text("hoge"),
          displayTimer(),
          buttons(context),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget displayTimer() {
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

  Widget buttons(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 50,
              margin: EdgeInsets.only(right: 10.0),
              color: Colors.lightGreenAccent,
              child: TextButton(
                  child: Text('SAVE'),
                  onPressed: () {
                    _updateTimer();
                    Navigator.pop(context);
                    // TODO: 戻った時に再描画 https://flutter.dev/docs/cookbook/navigation/returning-data
                  }),
            ),
            Container(
              width: 100,
              height: 50,
              margin: EdgeInsets.only(left: 10.0),
              color: Colors.redAccent,
              child: TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ));
  }
}
