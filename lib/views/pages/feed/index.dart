import 'package:campy/components/buttons/fabs.dart';
import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/inputs/text_controller.dart';
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
  List<FeedInfo> allFeeds = [];
  Throttling thr = Throttling(duration: const Duration(seconds: 5));

  Future _loadData() async {
    final allFeeds = await getAllFeeds();
    if (!mounted) return;
    final searchVal = Provider.of<FeedSearchVal>(context, listen: false);
    if (searchVal.text.isNotEmpty) searchVal.clear();

    setState(() {
      this.allFeeds = allFeeds;
      this.allFeeds.addAll(FeedInfo.mocks(20));
      feeds = this.allFeeds;
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
  void didChangeDependencies() {
    thr.throttle(() {
      super.didChangeDependencies();
      final searchVal = Provider.of<FeedSearchVal>(context);
      if (searchVal.text.length < 2) {
        this.feeds = allFeeds;
      } else {
        this.feeds = allFeeds.where((element) {
          final t = searchVal.text;
          if (element.addr != null && element.addr!.contains(t))
            return true;
          else if (element.title.contains(t))
            return true;
          else if (element.hashTags.join(" ").contains(t))
            return true;
          else if (element.placeAround.contains(t))
            return true;
          else if (element.campKind.contains(t))
            return true;
          else if (element.content.contains(t))
            return true;
          else
            return false;
        }).toList();
      }
    });
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
