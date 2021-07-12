import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart'; // Androidでビルドできない
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'model/timer_model.dart';
import 'model/dot_indicator_model.dart';

import 'view/timer/display.dart';
import 'view/timer/buttons.dart';
import 'view/timer/edit.dart';

import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector_math;

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

class ArcPaint extends CustomPainter {
  int _initialMSec = 0;
  int _remainMsec = 0;

  ArcPaint(int initialMsec, int remainMsec) {
    _initialMSec = initialMsec;
    _remainMsec = remainMsec;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final startAngle = -vector_math.radians(90.0); // 0時の位置から
    double degree = _remainMsec / _initialMSec * 360;
    if (degree == 0.0) {
      degree = 360;
    }
    final sweepAngle = -vector_math.radians(degree);
    final useCenter = false;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircleIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return CustomPaint(
        size: const Size(300, 300),
        painter: ArcPaint((((timer.initialMin * 60) + timer.initialSec).toInt()) * 1000, (int.parse(timer.min) * 60 + int.parse(timer.sec)) * 1000 + int.parse(timer.msec) * 10),
      );
    });
  }
}

class CircleIndicatorForEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(builder: (context, timer, child) {
      return CustomPaint(size: const Size(300, 300), painter: ArcPaint(1, 1));
    });
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<TimerModel>(context, listen: false).restore();

    return Consumer<TimerModel>(builder: (context, timer, child) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // サークルインジケーター
          Container(child: timer.inEdit ? CircleIndicatorForEdit() : CircleIndicator(), margin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
          // タイマー表示
          Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(Provider.of<TimerModel>(context, listen: false).timerId),
            timer.inEdit ? DisplayEdit() : Display(),
          ]),
          // ボタン
          Container(child: timer.inEdit ? InEditButtons() : ControlButtons(), margin: EdgeInsets.fromLTRB(0, 400, 0, 0))
        ],
      );
    });
  }
}
