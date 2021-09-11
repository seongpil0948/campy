import 'package:campy/views/layouts/pyffold.dart';
import 'package:flutter/material.dart';

class FeedPostView extends StatelessWidget {
  const FeedPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pyffold(
        fButton: false,
        body: Container(
          child: Center(
              child: Text(
            "Post Feed Page",
            style: TextStyle(color: Colors.black),
          )),
        ));
  }
}
