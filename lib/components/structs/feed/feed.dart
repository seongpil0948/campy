import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

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
    return GestureDetector(
      onTap: () {
        final state = ctx.read<PyState>();
        state.currPageAction = PageAction.feedDetail(feedInfo.feedId);
        state.selectedFeed = feedInfo;
      },
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
          ])),
    );
  }
}

class FeedStatusRow extends StatefulWidget {
  const FeedStatusRow({
    Key? key,
    required PyUser currUser,
    required this.feed,
    this.iconSize = const {'width': 15.0, 'height': 15.0},
  })  : _currUser = currUser,
        super(key: key);

  final PyUser _currUser;
  final FeedInfo feed;
  final Map<String, double> iconSize;

  @override
  _FeedStatusRowState createState() => _FeedStatusRowState();
}

class _FeedStatusRowState extends State<FeedStatusRow> {
  void _updates() {
    setState(() {
      widget._currUser.update();
      widget.feed.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    final U = widget._currUser;
    final F = widget.feed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            U.favoriteFeeds.contains(F.feedId)
                ? IconButton(
                    onPressed: () {
                      U.favoriteFeeds.remove(F.feedId);
                      _updates();
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ))
                : IconButton(
                    onPressed: () {
                      U.favoriteFeeds.add(F.feedId);
                      _updates();
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
        //       width: iconSize['width'],
        //       height: iconSize['heihgt'],
        //     ),
        //     Text("  ${feed.comment}  "),
        //     // Text("  ${feed.comments.length}  "),
        //   ],
        // ),
        Row(
          children: <Widget>[
            Icon(Icons.share_rounded),
            Text("  ${F.sharedUserIds.length}  "),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.bookmark_border_outlined),
            Text("  ${F.bookmarkedUserIds.length}  "),
          ],
        ),
      ],
    );
  }
}
