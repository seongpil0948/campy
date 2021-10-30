import 'package:campy/repositories/auth_repository.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/repositories/place/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class PyAuth extends ChangeNotifier {
  bool _isAuthentic = false;
  AuthRepository authRepo = AuthRepository();
  FirebaseAuth _fireAuth = FirebaseAuth.instance;
  PyUser? _currUser;

  bool get isAuthentic => _isAuthentic;

  Future<PyUser> get currUser async {
    var user = _fireAuth.currentUser;
    await setUser(user!);
    return _currUser!;
  }

  Future<void> setUser(User user) async {
    final userId = user.providerData[0].uid!;
    var ref = getCollection(c: Collections.Users).doc(userId);
    var docSnapthot = await ref.get();
    if (docSnapthot.exists) {
      var user = PyUser.fromJson(docSnapthot.data() as Map<String, dynamic>);
      user.feeds = await getFeeds([userId]);
    }
    _currUser = PyUser(user: user, userId: userId);
  }

  void _updateLoginStatus(bool dest) {
    _isAuthentic = dest;
    notifyListeners();
  }

  void logout() {
    _updateLoginStatus(false);
    _currUser = null;
  }

  void handleAuthChange(User? user) {
    if (user == null) {
      logout();
    } else {
      if (_currUser != null) return;
      setUser(user);
      _updateLoginStatus(true);
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
