import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/utils/io.dart';
import 'package:flutter/material.dart';

class FeedThumnail extends StatelessWidget {
  const FeedThumnail({
    Key? key,
    required this.mq,
    required this.imgs,
    required this.feedInfo,
  }) : super(key: key);
  final FeedInfo feedInfo;
  final MediaQueryData mq;
  final Iterable<PyFile> imgs;

  @override
  Widget build(BuildContext ctx) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(children: [
          CachedNetworkImage(
              // FIXME: 동영상일때는 썸네일을 보여줄 수 있도록
              fit: BoxFit.cover,
              width: mq.size.width,
              imageUrl:
                  imgs.length > 0 ? imgs.first.url! : feedInfo.writer.photoURL),
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
                      Text(
                        feedInfo.writer.email ?? "",
                        style: Theme.of(ctx).textTheme.bodyText1,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    feedInfo.content,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(ctx).textTheme.bodyText1,
                  ),
                  Text(feedInfo.title,
                      style: Theme.of(ctx)
                          .textTheme
                          .headline3
                          ?.copyWith(color: Colors.white)),
                  Text(
                    feedInfo.hashTags.replaceAll(" ", " #"),
                    style: Theme.of(ctx).textTheme.bodyText1,
                  )
                ],
              ))
        ]));
  }
}
