import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter extends ChangeNotifier {
  int value = 1;

  increment() {
    value = value + 1;
    notifyListeners();
  }

  decrement() {
    value = value - 1;
    notifyListeners();
  }
}
