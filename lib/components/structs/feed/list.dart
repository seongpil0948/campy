import 'package:campy/components/structs/feed/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/utils/feed.dart';
import 'package:campy/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:campy/models/feed.dart';
import 'package:provider/provider.dart';

class FeedList extends StatelessWidget {
  final List<FeedInfo> feeds;
  FeedList({Key? key, required this.feeds}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return ListView(
      children: feeds.map((feedInfo) {
        return FutureBuilder<List<PyFile>>(
            future: imgsOfFeed(f: feedInfo, limit: 1),
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
                child: FeedThumnail(
                  mq: mq,
                  img: imgs.first,
                  feedInfo: feedInfo,
                  tSize: ThumnailSize.Medium,
                ),
              );
            });
      }).toList(),
    );
  }
}

class GridFeeds extends StatelessWidget {
  const GridFeeds({
    Key? key,
    required this.feeds,
    required this.mq,
    required PyUser currUser,
  })  : _currUser = currUser,
        super(key: key);

  final List<FeedInfo> feeds;
  final MediaQueryData mq;
  final PyUser _currUser;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: feeds.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, idx) {
          final f = feeds[idx];
          return Card(
              elevation: 4.0,
              child: Container(
                width: mq.size.width / 2.5,
                height: mq.size.height / 3,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Provider.value(
                            value: _currUser,
                            child: FeedStatusRow(
                              feed: f,
                              tSize: ThumnailSize.Small,
                              U: _currUser,
                            ))),
                    Expanded(
                        flex: 3,
                        child: FutureBuilder<List<PyFile>>(
                            future: imgsOfFeed(f: f, limit: 1),
                            builder: (ctx, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                    child: CircularProgressIndicator());
                              final imgs = snapshot.data!;
                              return FeedThumnail(
                                  mq: mq,
                                  img: imgs.first,
                                  feedInfo: f,
                                  tSize: ThumnailSize.Small);
                            }))
                  ],
                ),
              ));
        });
  }
}
