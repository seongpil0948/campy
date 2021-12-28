import 'dart:async';

import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/store/product.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';

final defaultPage = PageAction.chat();

class PyState extends ChangeNotifier {
  PageAction _currPageAction = defaultPage;
  bool endSplash = false;
  bool _isLoading = false;
  FeedInfo? selectedFeed;
  InheritProduct? selectedProd;
  PyUser? selectedUser; // Null If Me

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
