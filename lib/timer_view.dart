import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart'; // Androidでビルドできない
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';

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
      new TimerWidget(),
      new TimerWidget(),
      new TimerWidget(),
    ];

    double _position = 0;

    // TODO: ページ切り替えにインジケータをつける
    // ref: https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824

    return Scaffold(
        appBar: AppBar(title: Text("Flutter Clock"), actions: <Widget>[]),
        floatingActionButton: EditButton(),
        // TODO: ダークモード？
        body: IconTheme(
            data: IconThemeData(color: Colors.black.withOpacity(0.8)),
            child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
              PageView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_pages[index % _pages.length], Container(child: DotsIndicator(dotsCount: _pages.length, position: _position), margin: EdgeInsets.fromLTRB(0, 50, 0, 0))]);
                  },
                  onPageChanged: (int page) {
                    Provider.of<TimerModel>(context, listen: false).timerId = "timer${page % _pages.length + 1}";
                    Provider.of<TimerModel>(context, listen: false).reset();

                    _position = (page % _pages.length).toDouble();
                  }),
            ])));
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<TimerModel>(context, listen: false).restore();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Consumer<TimerModel>(builder: (context, timer, child) {
          return Column(children: [
            Text(Provider.of<TimerModel>(context, listen: false).timerId),
            timer.inEdit ? DisplayEdit() : Display(),
            timer.inEdit ? InEditButtons() : ControlButtons(),
          ]);
        })
      ],
    );
  }
}
