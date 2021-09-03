import 'package:campy/repositories/auth_repository.dart';
import 'package:campy/views/router/state.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final appState = PyState();

  @override
  Widget build(BuildContext ctx) {
    var mq = MediaQuery.of(ctx);
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          "assets/images/mock.jpg",
          fit: BoxFit.cover,
          height: mq.size.height,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => appState.authRepo
                      .login(LoginStyle.Social, SocialLoginWith.Google),
                  child: Text("Google Login")),
              ElevatedButton(
                onPressed: () => appState.authRepo
                    .login(LoginStyle.Social, SocialLoginWith.Facebook),
                child: Text("Facebook Login"),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
