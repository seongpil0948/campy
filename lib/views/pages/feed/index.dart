import 'package:campy/components/buttons/fabs.dart';
import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/structs/feed/list.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/repositories/place/feed.dart';
import 'package:throttling/throttling.dart';
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
  Throttling thr = Throttling(duration: const Duration(seconds: 5));

  Future _loadData() async {
    final feeds = await getAllFeeds();
    if (!mounted) return;
    setState(() {
      this.feeds = feeds;
      this.feeds.addAll(FeedInfo.mocks(20));
      isLoading = false;
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    this.thr.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Pyffold(
        fButton: FeedFab(),
        body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              thr.throttle(() {
                if (!isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  _loadData();
                  setState(() {
                    isLoading = true;
                  });
                }
              });
              return true;
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
