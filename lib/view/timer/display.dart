import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clock/model/timer_model.dart';

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
