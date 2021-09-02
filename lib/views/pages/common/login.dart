import 'package:campy/repositories/auth_repository.dart';
import 'package:campy/views/router/state.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final appState = PyState();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("로그인페이지"),
            ElevatedButton(
                onPressed: () {
                  appState.authRepo
                      .login(LoginStyle.Social, SocialLoginWith.Google);
                },
                child: Text("구글"))
          ],
        ),
      ),
    ));
  }
}
