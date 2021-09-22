import 'package:campy/views/components/buttons/fabs.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:flutter/material.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Pyffold(
      fButton: FeedFab(),
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
