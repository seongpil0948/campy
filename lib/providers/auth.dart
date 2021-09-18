import 'package:campy/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class PyAuth extends ChangeNotifier {
  bool _isAuthentic = false;
  AuthRepository authRepo = AuthRepository();
  FirebaseAuth _fireAuth = FirebaseAuth.instance;
  PyUser? _currUser;

  bool get isAuthentic => _isAuthentic;

  PyUser? get currUser {
    if (isAuthentic && _currUser == null) {
      var user = _fireAuth.currentUser;
      if (user != null) {
        _currUser = PyUser(user: user);
      }
    }
    return _currUser;
  }

  void _updateLoginStatus(bool dest) {
    _isAuthentic = dest;
    notifyListeners();
  }

  void logout() {
    print(
        'FirebaseAuth: $_fireAuth _isAuthentic: $_isAuthentic User is currently signed out!');
    _updateLoginStatus(false);
    _currUser = null;
  }

  void handleAuthChange(User? user) {
    print("In authStateChanges $user");
    if (user == null) {
      logout();
    } else {
      if (_currUser != null) return;
      _currUser = PyUser(user: user);
      _updateLoginStatus(true);
      print('\nCurrent User: $_currUser is signed in!\n');
    }
  }

  void socialLogin(LoginStyle style, SocialLoginWith social) async {
    UserCredential? c;
    if (style == LoginStyle.Social) {
      switch (social) {
        case SocialLoginWith.Google:
          c = await authRepo.loginWithGoogle();
          break;
        case SocialLoginWith.Facebook:
          c = await authRepo.loginWithFacebook();
          break;
        case SocialLoginWith.Ignore:
          break;
      }
    }
    _updateLoginStatus(true);
  }

  // === Singleton ===
  PyAuth._onlyOne() {
    _fireAuth.authStateChanges().listen((User? user) => handleAuthChange(user));
  }
  static final PyAuth _instance = PyAuth._onlyOne();
  factory PyAuth() {
    return _instance;
  }
  // === Singleton End ===
}

enum LoginStyle { Social }

enum SocialLoginWith { Google, Facebook, Ignore }
