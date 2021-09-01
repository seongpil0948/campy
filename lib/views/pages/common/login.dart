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
                  appState.authRepo.login();
                  print("$appState");
                },
                child: Text("로그인하기"))
          ],
        ),
      ),
    ));
  }
}
