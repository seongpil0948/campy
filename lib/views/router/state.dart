import 'package:flutter/material.dart';
import 'path.dart';

final defaultPage = PageAction.place();

class PyAppState extends ChangeNotifier {
  PageAction currPageAction;
  // === Singleton ===
  PyAppState._onlyOne() : currPageAction = defaultPage;
  static final PyAppState _instance = PyAppState._onlyOne();
  factory PyAppState() {
    return _instance;
  }
  // === Singleton End ===

  void resetCurrentAction() {
    currPageAction = PageAction.feed();
  }
}
