import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends ChangeNotifier {
  bool _isAuthentic = false;
  FirebaseAuth _fireAuth = FirebaseAuth.instance;

  AuthRepository() {
    print("Initial Auth $_fireAuth.");
    _fireAuth.authStateChanges().listen((User? user) => handleAuthChange(user));
  }

  bool get isAuthentic => _isAuthentic;

  void _updateLoginStatus(bool dest) {
    _isAuthentic = dest;
    notifyListeners();
  }

  void logout() {
    print(
        'FirebaseAuth: $_fireAuth _isAuthentic: $_isAuthentic User is currently signed out!');
    _updateLoginStatus(false);
  }

  void login(LoginStyle style, SocialLoginWith social) async {
    UserCredential c;
    switch (style) {
      case LoginStyle.Social:
        c = await loginWithGoogle();
        break;
    }
    print("Result of Login Credential: $c ");
    _updateLoginStatus(true);
  }

  void handleAuthChange(User? user) {
    print("In authStateChanges $user");
    if (user == null) {
      logout();
    } else {
      print('User is signed in!');
    }
  }
}

enum LoginStyle { Social }

enum SocialLoginWith { Google, Facebook, Ignore }

Future<UserCredential> loginWithGoogle() async {
  GoogleSignInAccount? googleUser;
  try {
    googleUser = await GoogleSignIn().signIn();
  } catch (e) {
    print("Login Error $e");
  }

  if (googleUser != null) {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  throw ("=== Google Login Fail ===");
}
