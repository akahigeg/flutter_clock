import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clock/model/timer_view_model.dart';

import 'package:flutter_clock/timer_setting.dart';

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey,
        ),
        child: IconButton(icon: Icon(Icons.handyman_rounded), onPressed: timer.startEdit, key: Key("edit_button")),
        // child: TextButton(child: Text('Edit', style: TextStyle(color: Colors.white)), onPressed: timer.startEdit, key: Key("edit_button")),
      );
    });
  }
}

class DisplayEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                upDownButton(context, "up", "min"),
                Text(
                  '${timer.min}',
                  style: Theme.of(context).textTheme.headline3,
                ),
                upDownButton(context, "down", "min"),
              ]),
              Text(
                ':',
                style: Theme.of(context).textTheme.headline3,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                upDownButton(context, "up", "sec"),
                Text(
                  '${timer.sec}',
                  style: Theme.of(context).textTheme.headline3,
                ),
                upDownButton(context, "down", "sec"),
              ]),
            ],
          ));
    });
  }

  Widget upDownButton(BuildContext context, String upOrDown, String minOrSec) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
          width: 40,
          height: 25,
          child: ElevatedButton(
              child: Icon(upOrDown == "up" ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                onPrimary: Colors.white,
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
              }));
    });
  }
}

class InEditButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(builder: (context, timer, child) {
      return Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(right: 30.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent,
                ),
                child: TextButton(child: Text('UPDATE', style: TextStyle(color: Colors.black)), onPressed: timer.finishEdit),
              ),
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(left: 30.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
                child: TextButton(child: Text('CANCEL', style: TextStyle(color: Colors.white)), onPressed: timer.cancelEdit),
              )
            ],
          ));
    });
  }
}
