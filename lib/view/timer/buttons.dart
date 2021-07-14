import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clock/model/timer_view_model.dart';

class ControlButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              timer.isStart ? StopButton() : StartButton(),
              ResetButton(),
            ],
          ));
    });
  }
}

class StartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
        width: 100,
        height: 50,
        margin: EdgeInsets.only(right: 10.0),
        color: Colors.lightGreenAccent,
        child: TextButton(child: Text('START'), onPressed: timer.start, key: Key("start_button")),
      );
    });
  }
}

class StopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
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
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
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
