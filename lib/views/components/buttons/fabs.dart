import 'package:campy/models/state.dart';
import 'package:campy/views/router/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
