import 'package:campy/utils/responsive.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          "assets/images/splash_back_${fileNumberByRatio(mq.devicePixelRatio)}.png",
          fit: BoxFit.cover,
          height: mq.size.height,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.size.width / 3.2),
          child: Image.asset("assets/images/splash_fore.png"),
        ),
      ],
    );
  }
}
