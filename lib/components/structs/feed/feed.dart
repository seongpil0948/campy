import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/sns/share.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

enum ThumnailSize { Medium, Small }

class FeedThumnail extends StatelessWidget {
  const FeedThumnail({
    Key? key,
    required this.mq,
    this.img,
    required this.feedInfo,
    required this.tSize,
  }) : super(key: key);
  final FeedInfo feedInfo;
  final MediaQueryData mq;
  final PyFile? img;
  final ThumnailSize tSize;

  @override
  Widget build(BuildContext ctx) {
    final thumnail = GestureDetector(
      onTap: () {
        final state = ctx.read<PyState>();
        state.currPageAction = PageAction.feedDetail(feedInfo.feedId);
        state.selectedFeed = feedInfo;
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(children: [
            if (img == null || img!.file == null)
              CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: mq.size.width,
                  height: mq.size.height / 2.1,
                  imageUrl: img?.url ?? feedInfo.writer.profileImage)
            else if (img!.file != null)
              loadFile(f: img!, ctx: ctx),
            Positioned(
                bottom: tSize == ThumnailSize.Medium ? mq.size.height / 30 : 0,
                left: mq.size.width / 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tSize == ThumnailSize.Medium)
                      UserRow(feedInfo: feedInfo),
                    SizedBox(height: 10),
                    Text(
                      feedInfo.content,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(ctx).textTheme.bodyText1,
                    ),
                    Text(feedInfo.title,
                        style: tSize == ThumnailSize.Medium
                            ? Theme.of(ctx)
                                .textTheme
                                .headline4
                                ?.copyWith(color: Colors.white)
                            : Theme.of(ctx)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.white)),
                    Text(
                      feedInfo.hashTags.join(" "),
                      style: Theme.of(ctx).textTheme.bodyText1,
                    ),
                  ],
                ))
          ])),
    );
    return thumnail;
  }
}

class FeedStatusRow extends StatefulWidget {
  final ThumnailSize tSize;
  final PyUser U;
  final FeedInfo feed;
  final Map<String, double> iconSize;
  const FeedStatusRow({
    Key? key,
    required this.feed,
    required this.U,
    this.tSize = ThumnailSize.Medium,
    this.iconSize = const {'width': 15.0, 'height': 15.0},
  }) : super(key: key);

  @override
  _FeedStatusRowState createState() => _FeedStatusRowState();
}

class _FeedStatusRowState extends State<FeedStatusRow> {
  void _updates(PyUser u) {
    setState(() {
      u.update();
      widget.feed.update();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    final U = widget.U;
    final F = widget.feed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: <Widget>[
            U.favoriteFeeds.contains(F.feedId)
                ? IconButton(
                    onPressed: () {
                      U.favoriteFeeds.remove(F.feedId);
                      F.likeUserIds.remove(U.userId);
                      _updates(U);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ))
                : IconButton(
                    onPressed: () {
                      U.favoriteFeeds.add(F.feedId);
                      F.likeUserIds.add(U.userId);
                      _updates(U);
                    },
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                    ),
                  ),
            Text("  ${F.likeUserIds.length}  "),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Image(
        //       image: AssetImage("assets/images/comment_icon.png"),
        //       width: widget.iconSize['width'],
        //       height: widget.iconSize['heihgt'],
        //     ),
        //     Text("  ${F}  "),
        //     // Text("  ${feed.comments.length}  "),
        //   ],
        // ),
        Row(
          children: <Widget>[
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: ctx,
                      builder: (ctx) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.account_box),
                              title: const Text('Twitter'),
                              onTap: () async {
                                snsShare(SocialShare.Twitter, F);
                                F.sharedUserIds.add(F.feedId);
                                widget.feed.update();
                                Navigator.pop(ctx);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.videocam),
                              title: const Text('Email'),
                              onTap: () {
                                snsShare(SocialShare.Email, F);
                                F.sharedUserIds.add(F.feedId);
                                widget.feed.update();
                                Navigator.pop(ctx);
                              },
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.share_rounded)),
            Text("  ${F.sharedUserIds.length}  "),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Icon(Icons.bookmark_border_outlined),
        //     Text("  ${F.bookmarkedUserIds.length}  "),
        //   ],
        // ),
        if (widget.tSize == ThumnailSize.Medium) FollowBtn(currUser: U, F: F)
      ],
    );
  }
}
