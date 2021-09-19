import 'package:campy/models/auth.dart';
import 'package:campy/views/utils/responsive.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    var mq = MediaQuery.of(ctx);
    final auth = ctx.read<PyAuth>();
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
              LoginButton(
                mq: mq,
                aImg: "assets/images/google_login.png",
                tap: () =>
                    auth.socialLogin(LoginStyle.Social, SocialLoginWith.Google),
              ),
              SizedBox(height: 10),
              LoginButton(
                mq: mq,
                aImg: "assets/images/facebook_login.png",
                tap: () => auth.socialLogin(
                    LoginStyle.Social, SocialLoginWith.Facebook),
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

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.mq,
    required this.aImg,
    required this.tap,
  }) : super(key: key);

  final MediaQueryData mq;
  final String aImg;
  final Function tap;

  @override
  Widget build(BuildContext ctx) {
    return InkWell(
        onTap: () => tap(),
        splashColor: Theme.of(ctx).primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.size.width / 7),
          child: Image.asset(aImg),
        ));
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
      margin: EdgeInsets.symmetric(vertical: 30),
      child: w,
    );
  }
}
