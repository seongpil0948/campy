import 'package:campy/models/feed.dart';
import 'package:campy/repositories/store/feed.dart';
import 'package:campy/views/components/buttons/fabs.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/components/structs/feed/list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// FIXME: 전부다 갈아없어여함
/// 프로바이더로 전체화면 말고 리스트 보여주는 부분만 받아오면 리빌드 하고
/// 프로그래스바 뜰때 기존 피드는 없어지지 않는 상태로
/// https://medium.com/@jun.chenying/flutter-tutorial-part-5-listview-pagination-scroll-up-to-load-more-ed132f6a06be

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
      print("=== Call Set State Response Feed Is: $feeds ==");
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
