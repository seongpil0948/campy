import 'package:flutter/material.dart';

class PyWhiteButton extends StatelessWidget {
  Widget? widget;
  PyWhiteButton({
    Key? key,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        onPressed: () {},
        child: widget != null ? widget : null);
  }
}
