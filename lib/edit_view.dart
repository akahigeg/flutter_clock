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
        child: Column(children: [
          Text("hoge"),
          buttons(context),
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buttons(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 50,
              margin: EdgeInsets.only(right: 10.0),
              color: Colors.lightGreenAccent,
              child: TextButton(
                  child: Text('SAVE'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Container(
              width: 100,
              height: 50,
              margin: EdgeInsets.only(left: 10.0),
              color: Colors.redAccent,
              child: TextButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ));
  }
}
