import 'package:campy/models/state.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class FeedFab extends StatelessWidget {
  const FeedFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Consumer<PyState>(builder: (ctx, state, child) {
      return FloatingActionButton(
        onPressed: () {
          state.currPageAction = PageAction.feedPost();
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
      );
    });
  }
}
