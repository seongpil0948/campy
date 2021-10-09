import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/auth.dart';
import 'package:campy/models/comment.dart';
import 'package:campy/models/common.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

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
    var _commentController = TextEditingController();
    return Scaffold(
        drawer: PyDrawer(),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: mq.size.width,
                    height: mq.size.height / 3,
                    child: PyCarousel(fs: feed.files)),
                Container(
                  width: mq.size.width * 0.6,
                  padding: EdgeInsets.only(left: 12),
                  margin: EdgeInsets.symmetric(vertical: mq.size.height / 100),
                  child: _FeedStatusRow(
                      currUser: _currUser, feed: feed, iconSize: iconSize),
                ),
                _Divider(),
                Text(feed.hashTags),
                _Divider(),
                _PlaceInfo(mq: mq, iconImgH: iconImgH),
                // Container(
                //   child: Text("댓글(${feed.comments.length})"),
                // )
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: _CommentPost(
              mq: mq,
              currUser: _currUser,
              commentController: _commentController,
              feed: feed,
            ),
          )
        ]));
    ;
  }
}

class _CommentPost extends StatelessWidget {
  const _CommentPost(
      {Key? key,
      required this.mq,
      required PyUser currUser,
      required TextEditingController commentController,
      required this.feed})
      : _currUser = currUser,
        _commentController = commentController,
        super(key: key);

  final MediaQueryData mq;
  final PyUser _currUser;
  final TextEditingController _commentController;
  final FeedInfo feed;

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: mq.size.width - 40,
      margin: EdgeInsets.only(left: 20),
      decoration: new BoxDecoration(
        color: Theme.of(ctx).primaryColor,
        border: Border.all(color: Colors.black, width: 0.0),
        borderRadius: const BorderRadius.all(Radius.circular(60)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(_currUser.profileImage)),
            ),
          ),
          Expanded(
              flex: 6,
              child: Container(
                height: mq.size.height / 23,
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send),
                        iconSize: 18,
                        color: Theme.of(ctx).primaryColor),
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(60),
                    //         bottomLeft: Radius.circular(60)))
                  ),
                  onSubmitted: (String txt) {
                    final commentId = Uuid().v4();
                    final comment =
                        Comment(id: commentId, writer: _currUser, content: txt);
                    final cj = comment.toJson();
                    print("In Submit Comment: $cj");
                    getCollection(Collections.Users)
                        .doc(_currUser.userId)
                        .collection("feeds")
                        .doc(feed.feedId)
                        .collection('comments')
                        .doc(commentId)
                        .set(cj)
                        .then((value) {
                      print("Post Comment is Successed ");
                    }).catchError((e) {
                      print("Post Comment is Restricted: $e");
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class _PlaceInfo extends StatelessWidget {
  const _PlaceInfo({
    Key? key,
    required this.mq,
    required this.iconImgH,
  }) : super(key: key);

  final MediaQueryData mq;
  final double iconImgH;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.size.height / 4,
      margin: EdgeInsets.symmetric(vertical: 20),
      width: mq.size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Image.asset(
                    "assets/images/feed_icon_filled.png",
                    height: iconImgH,
                  ),
                  Text(" 글램핑")
                ]),
                SizedBox(height: 10),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    width: 1,
                  ),
                  Image.asset(
                    "assets/images/map_marker.png",
                    height: iconImgH - 3,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 180),
                    margin: EdgeInsets.only(left: mq.size.width / 80),
                    child: Text(
                      "경기도 광명시 가림일로",
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Image.asset(
                    "assets/images/won.png",
                    height: iconImgH - 7,
                  ),
                  Text("  유료 : 1일 10만원")
                ]),
                SizedBox(height: 10),
                Row(children: [
                  Image.asset(
                    "assets/images/caution.png",
                    height: iconImgH - 7,
                  ),
                  Text(
                    "  주변 마켓 없음",
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
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

class _FeedStatusRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            _currUser.favoriteFeeds.contains(feed.feedId)
                ? IconButton(
                    onPressed: () {
                      _currUser.favoriteFeeds.remove(feed.feedId);
                      _currUser.update();
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ))
                : IconButton(
                    onPressed: () {
                      _currUser.favoriteFeeds.add(feed.feedId);
                      _currUser.update();
                    },
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                    ),
                  ),
            Text("  ${feed.likeUserIds.length}  "),
          ],
        ),
        Row(
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/comment_icon.png"),
              width: iconSize['width'],
              height: iconSize['heihgt'],
            ),
            // Text("  ${feed.comments.length}  "),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.share_rounded),
            Text("  ${feed.sharedUserIds.length}  "),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.bookmark_border_outlined),
            Text("  ${feed.bookmarkedUserIds.length}  "),
          ],
        ),
      ],
    );
  }
}
