import 'package:flutter/material.dart';

class WrongView extends StatelessWidget {
  const WrongView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text("Something WrongView"),
          ),
        ),
      ),
    );
  }
}
