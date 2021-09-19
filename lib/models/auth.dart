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
        _currUser = PyUser(user: user, userId: user.providerData[0].uid!);
      }
    }
    return _currUser;
  }

  void _updateLoginStatus(bool dest) {
    _isAuthentic = dest;
    notifyListeners();
  }

  void logout() {
    print("signed out!");
    _updateLoginStatus(false);
    _currUser = null;
  }

  void handleAuthChange(User? user) {
    print("In authStateChanges $user");
    if (user == null) {
      logout();
    } else {
      if (_currUser != null) return;
      _currUser = PyUser(user: user, userId: user.providerData[0].uid!);
      _updateLoginStatus(true);
      print('\nCurrent User: $_currUser is signed in!\n');
    }
  }

  void socialLogin(LoginStyle style, SocialLoginWith social) async {
    if (style == LoginStyle.Social) {
      switch (social) {
        case SocialLoginWith.Google:
          await authRepo.loginWithGoogle();
          break;
        case SocialLoginWith.Facebook:
          await authRepo.loginWithFacebook();
          break;
        case SocialLoginWith.Ignore:
          break;
      }
    }
    _updateLoginStatus(true);
  }

  @override
  String toString() {
    return ">>> PyAuth: isAuthentic: $isAuthentic \n Curr User: $currUser";
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
