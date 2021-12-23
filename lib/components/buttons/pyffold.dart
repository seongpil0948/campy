import 'package:campy/models/state.dart';
import 'package:campy/views/layouts/appbar.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class Pyffold extends StatelessWidget {
  final Widget body;
  final Widget? fButton;
  final BottomSheet? bSheet;

  Pyffold({
    Key? key,
    this.fButton,
    this.bSheet,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final toolbarH = mq.size.height / 6;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(toolbarH),
          child: PyAppBar(toolbarH: toolbarH)),
      drawer: PyDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fButton,
      body: ctx.watch<PyState>().isLoading
          ? Center(child: CircularProgressIndicator())
          : body,
      bottomSheet: bSheet,
    );
  }
}
