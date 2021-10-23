import 'package:flutter/material.dart';

class DotCircle extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  const DotCircle(
      {Key? key,
      required this.color,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ));
  }
}
