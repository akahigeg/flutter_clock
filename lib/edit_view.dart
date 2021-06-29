import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';

class EditView extends StatefulWidget {
  EditView({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  State<StatefulWidget> createState() {
    return _EditViewState();
  }
}

class _EditViewState extends State<EditView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Edit:',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
