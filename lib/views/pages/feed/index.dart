import 'package:campy/models/feed.dart';
import 'package:campy/repositories/place/feed.dart';
import 'package:campy/views/components/buttons/fabs.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/components/structs/feed/list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedCategoryView extends StatefulWidget {
  const FeedCategoryView({Key? key}) : super(key: key);

  @override
  _FeedCategoryViewState createState() => _FeedCategoryViewState();
}

class _FeedCategoryViewState extends State<FeedCategoryView> {
  bool isLoading = false;
  List<FeedInfo> feeds = [];

  Future _loadData() async {
    print("=== Call Load Data ==");
    final feeds = await getAllFeeds();
    if (!mounted) return;
    setState(() {
      this.feeds = feeds;
      isLoading = false;
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
// if (userSnapShot.hasError) {
//   return Text('Something went wrong of Users');
// } else if (userSnapShot.connectionState == ConnectionState.waiting) {
//     return Text("Loading of Users");
    return Pyffold(
        fButton: FeedFab(),
        body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // https://pub.dev/packages/throttling
              print("Scroll Info: $scrollInfo");
              if (!isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadData();
                setState(() {
                  isLoading = true;
                });
              }
              return false;
            },
            child: Stack(
              children: [
                Provider.value(
                  value: feeds,
                  child: FeedList(feeds: feeds),
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            )));
  }
}
