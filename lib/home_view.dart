import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart'; // Androidでビルドできない
import 'package:provider/provider.dart';

import 'model/timer_model.dart';
import 'timer_setting.dart';

class FlutterTimer extends StatelessWidget {
  FlutterTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<TimerModel>(context, listen: false).restore();

    return Scaffold(
      appBar: AppBar(title: Text("Flutter Clock"), actions: <Widget>[]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<TimerModel>(builder: (context, timer, child) {
              return Column(children: [
                timer.inEdit ? DisplayEdit() : Display(),
                timer.inEdit ? InEditButtons() : ControlButtons(),
              ]);
            })
          ],
        ),
      ),
    );
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
            '${timer.min}:',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            '${timer.sec}:',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            '${timer.msec}',
            style: Theme.of(context).textTheme.headline5,
          ),
          // TODO: msecのサイズ小さく
        ],
      );
    });
  }
}

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              timer.isStart ? StopButton() : StartButton(),
              ResetButton(),
              EditButton(),
            ],
          ));
    });
  }
}

class StartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Container(
        width: 100,
        height: 50,
        margin: EdgeInsets.only(right: 10.0),
        color: Colors.lightGreenAccent,
        // TODO: 00:00:00の場合はSTARTを押せないように
        child: TextButton(child: Text('START'), onPressed: timer.start, key: Key("start_button")),
      );
    });
  }
}

class StopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Container(
        width: 100,
        height: 50,
        margin: EdgeInsets.only(right: 10.0),
        color: Colors.redAccent,
        child: TextButton(child: Text('STOP'), onPressed: timer.stop, key: Key("stop_button")),
      );
    });
  }
}

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Container(
        width: 100,
        height: 50,
        margin: EdgeInsets.only(left: 10.0),
        color: Colors.greenAccent,
        child: TextButton(child: Text('RESET'), onPressed: timer.reset, key: Key("reset_button")),
      );
    });
  }
}

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Container(
        width: 100,
        height: 50,
        margin: EdgeInsets.only(left: 10.0),
        color: Colors.greenAccent,
        child: TextButton(child: Text('EDIT'), onPressed: timer.startEdit, key: Key("edit_button")),
      );
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
              '${timer.min}',
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
              '${timer.sec}',
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
              timer.changeMin(TimerSetting.changeMin(timer.min, upOrDown));
            } else {
              timer.changeSec(TimerSetting.changeSec(timer.sec, upOrDown));
            }
          },
          // TODO: 長押し 以下のコードでなぜか動かない
          onLongPress: () {
            print("longpress");
            if (minOrSec == "min") {
              timer.changeMin(TimerSetting.changeMin(timer.min, upOrDown));
            } else {
              timer.changeSec(TimerSetting.changeSec(timer.sec, upOrDown));
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
