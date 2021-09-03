import 'package:flutter/material.dart';
import 'package:campy/views/router/state.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    var mq = MediaQuery.of(ctx);
    final appState = PyState();
    return Scaffold(
      body: Container(
        child: Column(
          children: [Text("data")],
        ),
      ),
    );
  }
}
