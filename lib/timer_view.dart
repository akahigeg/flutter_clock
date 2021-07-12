import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart'; // Androidでビルドできない
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'model/timer_model.dart';
import 'model/dot_indicator_model.dart';

import 'view/timer/display.dart';
import 'view/timer/buttons.dart';
import 'view/timer/edit.dart';

import 'dart:math';

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

    return Scaffold(
        appBar: AppBar(title: Text("Flutter Clock"), actions: <Widget>[]),
        floatingActionButton: EditButton(),
        // TODO: ダークモード？
        body: IconTheme(
            data: IconThemeData(color: Colors.black.withOpacity(0.8)),
            child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
              Container(
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: CirclePaint(),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
              PageView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return _pages[index % _pages.length];
                  },
                  onPageChanged: (int page) {
                    // アクティブなタイマーの切り替え
                    Provider.of<TimerModel>(context, listen: false).timerId = "timer${page % _pages.length + 1}";
                    Provider.of<TimerModel>(context, listen: false).reset();

                    // ドットインジケーターのポジションの更新
                    Provider.of<DotIndicatorModel>(context, listen: false).position = (page % _pages.length).toDouble();
                  }),
              Positioned(
                  child: Consumer<DotIndicatorModel>(builder: (context, di, child) {
                    return Container(child: DotsIndicator(dotsCount: _pages.length, position: di.position), margin: EdgeInsets.fromLTRB(0, 50, 0, 0));
                  }),
                  bottom: 180)
            ])));
  }
}

class CirclePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height);
    canvas.drawCircle(center, radius, paint);
  }

  // 再描画する必要なし
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
