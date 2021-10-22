import 'package:campy/models/auth.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/components/structs/feed/comment.dart';
import 'package:campy/views/components/structs/place/place.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class FeedDetailView extends StatelessWidget {
  FeedDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final state = ctx.read<PyState>();
    final feed = state.selectedFeed!;
    final _currUser = ctx.watch<PyAuth>().currUser!;
    final iconImgH = 24.0;
    final iconSize = {'width': 15.0, 'height': 15.0};
    final T = Theme.of(ctx).textTheme;
    var _commentController = TextEditingController();
    const leftPadding = 20.0;
    return Scaffold(
        drawer: PyDrawer(),
        body: Stack(children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: mq.size.height),
              child: Column(
                children: [
                  Container(
                      width: mq.size.width,
                      height: mq.size.height / 3,
                      child: PyCarousel(fs: feed.files)),
                  Container(
                    width: mq.size.width * 0.6,
                    padding: EdgeInsets.only(left: leftPadding),
                    margin:
                        EdgeInsets.symmetric(vertical: mq.size.height / 100),
                    child: _FeedStatusRow(
                        currUser: _currUser, feed: feed, iconSize: iconSize),
                  ),
                  _Divider(),
                  Text(feed.hashTags),
                  _Divider(),
                  PlaceInfo(mq: mq, iconImgH: iconImgH),
                  _Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: leftPadding),
                    child: CommentList(
                        feedId: feed.feedId, userId: _currUser.userId),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: CommentPost(
              mq: mq,
              currUser: _currUser,
              commentController: _commentController,
              feed: feed,
            ),
          )
        ]));
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Divider());
  }
}

class _FeedStatusRow extends StatefulWidget {
  const _FeedStatusRow({
    Key? key,
    required PyUser currUser,
    required this.feed,
    required this.iconSize,
  })  : _currUser = currUser,
        super(key: key);

  final PyUser _currUser;
  final FeedInfo feed;
  final Map<String, double> iconSize;

  @override
  __FeedStatusRowState createState() => __FeedStatusRowState();
}

class __FeedStatusRowState extends State<_FeedStatusRow> {
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
