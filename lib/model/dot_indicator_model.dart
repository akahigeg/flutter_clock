import 'package:flutter/material.dart';

class DotIndicatorModel extends ChangeNotifier {
  double _position = 0;

  double get position => _position;
  set position(double newPosition) {
    _position = newPosition;

    notifyListeners();
  }
}
