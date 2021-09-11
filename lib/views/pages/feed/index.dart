import 'package:campy/views/components/structs/feed/feed.dart';
import 'package:campy/views/layouts/pyffold.dart';
import 'package:flutter/material.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Pyffold(
      fButton: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            FeedWidget(),
            FeedWidget(),
            FeedWidget(),
          ],
        ),
      ),
    );
  }
}
