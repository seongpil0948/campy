import 'dart:async';

import 'package:campy/models/feed.dart';
import 'package:campy/repositories/store/product.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';

final defaultPage = PageAction.feed();

class PyState extends ChangeNotifier {
  late PageAction _currPageAction;
  bool endSplash = false;
  bool _isLoading = false;
  FeedInfo? selectedFeed;
  InheritProduct? selectedProd;

  PageAction get currPageAction => _currPageAction;
  set currPageAction(PageAction act) {
    if (_currPageAction.page.key == act.page.key ||
        _currPageAction.page.hashCode == act.page.hashCode) {
      act.state = PageState.replace;
    }
    _currPageAction = act;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool l) {
    _isLoading = l;
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
