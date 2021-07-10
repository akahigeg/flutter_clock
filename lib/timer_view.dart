import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart'; // Androidでビルドできない
import 'package:provider/provider.dart';

import 'model/timer_model.dart';

import 'view/timer/display.dart';
import 'view/timer/buttons.dart';
import 'view/timer/edit.dart';

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
