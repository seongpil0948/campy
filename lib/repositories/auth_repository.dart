import 'package:flutter/material.dart';

class AuthRepository extends ChangeNotifier {
  bool _isAuthentic = false;
  AuthRepository();

  bool get isAuthentic => _isAuthentic;

  void _updateLoginStatus(bool dest) {
    _isAuthentic = dest;
    notifyListeners();
  }

  void logout() => _updateLoginStatus(true);

  void login() => _updateLoginStatus(true);
}
