import 'package:flutter/material.dart';
import 'package:campy/views/router/path.dart';
import 'package:campy/utils/io.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/state.dart';
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
        final imgs = feedInfo.files
            .where((f) => f.ftype == PyFileType.Image && f.url != null);

        return GestureDetector(
          onTap: () {
            final state = ctx.read<PyState>();
            state.currPageAction = PageAction.feedDetail(feedInfo.feedId);
            state.selectedFeed = feedInfo;
          },
          child: Container(
            margin: EdgeInsets.all(20),
            height: mq.size.height / 3,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(children: [
                  CachedNetworkImage(
                      // FIXME: 동영상일때는 썸네일을 보여줄 수 있도록
                      fit: BoxFit.cover,
                      width: mq.size.width,
                      imageUrl: imgs.length > 0
                          ? imgs.first.url!
                          : feedInfo.writer.photoURL),
                  Positioned(
                      bottom: mq.size.height / 30,
                      left: mq.size.width / 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 15,
                                  backgroundImage: CachedNetworkImageProvider(
                                      feedInfo.writer.photoURL)),
                              SizedBox(width: 10),
                              Text(feedInfo.writer.email ?? "")
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            feedInfo.content,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(feedInfo.title,
                              style: Theme.of(ctx)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(color: Colors.white)),
                          Text(feedInfo.hashTags.replaceAll(" ", " #"))
                        ],
                      ))
                ])),
          ),
        );
      }).toList(),
    );
  }
}
