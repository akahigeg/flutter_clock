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
        width: 70,
        height: 70,
        margin: EdgeInsets.only(right: 30.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lightGreenAccent,
        ),
        child: TextButton(child: Text('START', style: TextStyle(color: Colors.black)), onPressed: timer.start, key: Key("start_button")),
      );
    });
  }
}

class StopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
        width: 70,
        height: 70,
        margin: EdgeInsets.only(right: 30.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
        ),
        child: TextButton(child: Text('STOP', style: TextStyle(color: Colors.white)), onPressed: timer.stop, key: Key("stop_button")),
      );
    });
  }
}

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
        width: 70,
        height: 70,
        margin: EdgeInsets.only(left: 30.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lightBlueAccent,
        ),
        child: TextButton(child: Text('RESET', style: TextStyle(color: Colors.black)), onPressed: timer.reset, key: Key("reset_button")),
      );
    });
  }
}
