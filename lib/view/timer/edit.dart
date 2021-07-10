import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clock/model/timer_model.dart';

import 'package:flutter_clock/timer_setting.dart';

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
