import 'package:campy/views/components/structs/feed/feed.dart';
import 'package:campy/views/layouts/appbar.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          shape: CircleBorder(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FeedWidget(),
              FeedWidget(),
              FeedWidget(),
            ],
          ),
        ));
  }
}
