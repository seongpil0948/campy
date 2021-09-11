import 'dart:async';

import 'package:campy/repositories/auth_repository.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';

final defaultPage = PageAction.feed();

class PyState extends ChangeNotifier {
  late PageAction _currPageAction;
  late AuthRepository authRepo;
  bool endSplash = false;

  bool get readyToMain => endSplash && authRepo.isAuthentic;

  PageAction get currPageAction => _currPageAction;
  set currPageAction(PageAction act) {
    _currPageAction = act;
    notifyListeners();
  }

  // === Singleton ===
  PyState._onlyOne() {
    currPageAction = defaultPage;
    authRepo = AuthRepository();
    Timer(Duration(seconds: 4), () {
      endSplash = true;
      notifyListeners();
    });
    authRepo.addListener(() {
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

  @override
  String toString() {
    return "currPageAction: $currPageAction \n authRepo: $authRepo \n readyToMain: $readyToMain";
  }
}
