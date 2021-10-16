import 'dart:async';

import 'package:campy/models/feed.dart';
import 'package:campy/models/product.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';

final defaultPage = PageAction.feed();

class PyState extends ChangeNotifier {
  late PageAction _currPageAction;
  bool endSplash = false;
  FeedInfo? selectedFeed;
  ProductInfo? selectedProd;

  PageAction get currPageAction => _currPageAction;
  set currPageAction(PageAction act) {
    _currPageAction = act;
    notifyListeners();
  }

  // === Singleton ===
  PyState._onlyOne() {
    currPageAction = defaultPage;
    Timer(Duration(seconds: 4), () {
      endSplash = true;
      notifyListeners();
    });
  }
  static final PyState _instance = PyState._onlyOne();
  factory PyState() {
    return _instance;
  }
  // === Singleton End ===
  void resetCurrentAction() {
    currPageAction = PageAction.feed();
  }
}
