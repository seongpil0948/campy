import 'package:campy/components/structs/feed/feed.dart';
import 'package:campy/utils/feed.dart';
import 'package:flutter/material.dart';
import 'package:campy/utils/io.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:campy/models/feed.dart';

class FeedList extends StatelessWidget {
  final List<FeedInfo> feeds;
  FeedList({Key? key, required this.feeds}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return ListView(
      children: feeds.map((feedInfo) {
        final imgs = imgsOfFeed(feedInfo);

        return Container(
          margin: EdgeInsets.all(20),
          height: mq.size.height / 3,
          child: FeedThumnail(mq: mq, imgs: imgs, feedInfo: feedInfo),
        );
      }).toList(),
    );
  }
}
