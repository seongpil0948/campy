import 'package:campy/views/layouts/pyffold.dart';
import 'package:flutter/material.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    // PyUser user = ctx.watch<PyState>().currUser!;
    return Pyffold(
      fButton: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FeedWidget(user: users[0]),
          ],
        ),
      ),
    );
  }
}
