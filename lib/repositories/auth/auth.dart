import 'package:campy/repositories/auth_repository.dart';
import 'package:campy/repositories/init.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campy/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PyAuth extends ChangeNotifier {
  bool _isAuthentic = false;
  AuthRepository authRepo = AuthRepository();
  FirebaseAuth _fireAuth = FirebaseAuth.instance;
  PyUser? _currUser;
  // Even if auth changed, the device token is same,
  // so it's initialized once per divice
  String? messageToken;

  bool get isAuthentic => _isAuthentic;

  Future<PyUser> get currUser async {
    if (_currUser != null) return _currUser!;
    var user = _fireAuth.currentUser;
    await setUser(user!);
    return _currUser!;
  }

  Future<void> setUser(User user) async {
    print("====== set User ====== ");
    // FIXME: 이거 왤케 많이 호출되냐
    final userId = user.providerData[0].uid!;
    var ref = getCollection(c: Collections.Users).doc(userId);
    var docSnapthot = await ref.get();
    _currUser = docSnapthot.exists
        ? PyUser.fromJson(docSnapthot.data() as Map<String, dynamic>)
        : PyUser(user: user, userId: userId);
    var u = _currUser!;
    if (u.messageToken != messageToken) {
      print("====== set messageToken ====== $messageToken");
      u.messageToken = messageToken;
      u.update();
    }
  }

  void _updateLoginStatus(bool dest) {
    _isAuthentic = dest;
    notifyListeners();
  }

  void logout() {
    _updateLoginStatus(false);
    _currUser = null;
  }

  Future<void> handleAuthChange(User? user) async {
    // device user auth changed
    if (user == null) {
      logout();
    } else {
      if (_currUser != null) return;
      if (messageToken == null) {
        messageToken = await FirebaseMessaging.instance.getToken();
      }
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
