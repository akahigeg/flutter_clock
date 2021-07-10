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
    final _pageController = PageController();

    final List<Widget> _pages = <Widget>[
      new TimerWidget("timer1"),
      new TimerWidget("timer2"),
      new TimerWidget("timer3"),
    ];

    // TODO: ページ切り替えにインジケータをつける
    // ref: https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824

    return Scaffold(
        appBar: AppBar(title: Text("Flutter Clock"), actions: <Widget>[]),
        floatingActionButton: EditButton(),
        body: new IconTheme(
            data: new IconThemeData(color: Colors.black.withOpacity(0.8)),
            child: new Stack(children: <Widget>[
              new PageView.builder(
                  physics: new AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return _pages[index % _pages.length];
                  },
                  onPageChanged: (int page) {
                    Provider.of<TimerModel>(context, listen: false).timerId = "timer${page % _pages.length + 1}";
                    Provider.of<TimerModel>(context, listen: false).reset();
                  })
            ])));
  }
}

class TimerWidget extends StatelessWidget {
  TimerWidget(this.timerId);

  final String timerId;

  @override
  Widget build(BuildContext context) {
    Provider.of<TimerModel>(context, listen: false).restore();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Consumer<TimerModel>(builder: (context, timer, child) {
            return Column(children: [
              Text(timerId),
              timer.inEdit ? DisplayEdit() : Display(),
              timer.inEdit ? InEditButtons() : ControlButtons(),
            ]);
          })
        ],
      ),
    );
  }
}
