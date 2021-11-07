import 'package:campy/components/structs/feed/feed.dart';
import 'package:campy/utils/feed.dart';
import 'package:campy/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:campy/models/feed.dart';

class FeedList extends StatelessWidget {
  final List<FeedInfo> feeds;
  FeedList({Key? key, required this.feeds}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return ListView(
      children: feeds.map((feedInfo) {
        return FutureBuilder<List<PyFile>>(
            future: imgsOfFeed(feedInfo),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData)
                return Center(
                    child: Container(
                        width: 40,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator()));
              final imgs = snapshot.data!;
              return Container(
                margin: EdgeInsets.all(20),
                height: mq.size.height / 3,
                child:
                    FeedThumnail(mq: mq, img: imgs.first, feedInfo: feedInfo),
              );
            });
      }).toList(),
    );
  }
}
