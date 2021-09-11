import 'package:campy/providers/state.dart';
import 'package:campy/views/layouts/appbar.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pyffold extends StatelessWidget {
  Widget body;
  bool fButton;

  Pyffold({
    Key? key,
    required this.fButton,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final toolbarH = mq.size.height / 8;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(toolbarH),
            child: PyAppBar(toolbarH: toolbarH)),
        drawer: PyDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: fButton == true ? PyFab() : null,
        body: body);
  }
}

class PyFab extends StatelessWidget {
  const PyFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Consumer<PyState>(builder: (ctx, state, child) {
      return FloatingActionButton(
        onPressed: () {
          print("Prev State: $state");
          state.currPageAction = PageAction.feedPost();
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
      );
    });
  }
}
