import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947_960_720.jpg",
      fit: BoxFit.fill,
      // height: mq.size.height / 3,
      // width: mq.size.width,
    );
  }
}
