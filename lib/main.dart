import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'timer_view.dart';
import './model/timer_model.dart';
import './model/dot_indicator_model.dart';

void main() {
  // runApp(ChangeNotifierProvider(create: (context) => TimerModel(), child: MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clock',
      theme: ThemeData.dark(),
      home: Providers(),
    );
  }
}

class Providers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [ChangeNotifierProvider(create: (context) => TimerModel()), ChangeNotifierProvider(create: (context) => DotIndicatorModel())], child: FlutterTimer());
  }
}
