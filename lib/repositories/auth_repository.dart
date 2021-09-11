import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends ChangeNotifier {
  bool _isAuthentic = false;
  FirebaseAuth _fireAuth = FirebaseAuth.instance;
  PyUser? currUser;

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
    currUser = null;
  }

  void socialLogin(LoginStyle style, SocialLoginWith social) async {
    UserCredential? c;
    if (style == LoginStyle.Social) {
      switch (social) {
        case SocialLoginWith.Google:
          c = await loginWithGoogle();
          break;
        case SocialLoginWith.Facebook:
          c = await loginWithFacebook();
          break;
        case SocialLoginWith.Ignore:
          break;
      }
    }
    _updateLoginStatus(true);
  }

  void handleAuthChange(User? user) {
    print("In authStateChanges $user");
    if (user == null) {
      logout();
    } else {
      currUser = PyUser(socialUser: user);
      _updateLoginStatus(true);
      print('\nCurrent User: $currUser is signed in!\n');
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

Future<UserCredential> loginWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
