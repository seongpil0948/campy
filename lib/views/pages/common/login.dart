import 'package:campy/repositories/auth_repository.dart';
import 'package:campy/views/router/state.dart';
import 'package:campy/views/utils/responsive.dart';
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
          // background image
          "assets/images/splash_back_${fileNumberByRatio(mq.devicePixelRatio)}.png",
          fit: BoxFit.fill,
          height: mq.size.height,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo_w_2.png",
                width: mq.size.width / 2,
                height: mq.size.height / 15,
                fit: BoxFit.cover,
              ),
              VmarginContainer(
                mq: mq,
                w: Text("캠피 서비스 이용을 위해 SNS 로그인을 해주세요"),
              ),
              ElevatedButton(
                  onPressed: () => appState.authRepo
                      .login(LoginStyle.Social, SocialLoginWith.Google),
                  child: Text("Google Login")),
              ElevatedButton(
                onPressed: () => appState.authRepo
                    .login(LoginStyle.Social, SocialLoginWith.Facebook),
                child: Text("Facebook Login"),
              ),
              VmarginContainer(
                mq: mq,
                w: Divider(
                  indent: mq.size.width / 6.5,
                  endIndent: mq.size.width / 6.5,
                  color: Colors.white,
                ),
              ),
              Text("로그인에 문제가 있으시면 여기를 눌러주세요"),
            ],
          ),
        ),
      ]),
    );
  }
}

class VmarginContainer extends StatelessWidget {
  const VmarginContainer({Key? key, required this.mq, required this.w})
      : super(key: key);

  final MediaQueryData mq;
  final Widget w;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: w,
    );
  }
}
