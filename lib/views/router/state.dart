import 'package:flutter/material.dart';
import 'path.dart';

final defaultPage = PageAction.place();

class PyState extends ChangeNotifier {
  PageAction currPageAction;
  // === Singleton ===
  PyState._onlyOne() : currPageAction = defaultPage;
  static final PyState _instance = PyState._onlyOne();
  factory PyState() {
    return _instance;
  }
  // === Singleton End ===

  void resetCurrentAction() {
    currPageAction = PageAction.feed();
  }
}
