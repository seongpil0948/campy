import 'dart:async';

import 'package:campy/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'path.dart';

final defaultPage = PageAction.place();

class PyState extends ChangeNotifier {
  late PageAction currPageAction;
  late AuthRepository authRepo;
  bool endSplash = false;

  bool get readyToMain => endSplash && authRepo.isAuthentic;

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
