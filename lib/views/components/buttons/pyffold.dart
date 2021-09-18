import 'package:campy/views/layouts/appbar.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';

class Pyffold extends StatelessWidget {
  final Widget body;
  final Widget? fButton;

  Pyffold({
    Key? key,
    this.fButton,
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
        floatingActionButton: fButton,
        body: body);
  }
}
