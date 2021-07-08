import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './home_view.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(create: (context) => TimerModel(), child: Clock()),
    );
  }
}
