import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/auth.dart';
import 'package:campy/models/state.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        drawer: PyDrawer(),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(
            children: [
              PyCarousel(fs: feed.files),
              Container(
                width: mq.size.width * 0.6,
                padding: EdgeInsets.only(left: 12),
                margin: EdgeInsets.symmetric(vertical: mq.size.height / 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: <Widget>[
                        _currUser.favoriteFeeds.contains(feed.feedId)
                            ? IconButton(
                                onPressed: () {
                                  // FIXME: 전체적 변경 사항있을경우 파이어 베이스로 업데이트 해주는 코드 필요
                                  if (feed.feedId != null)
                                    _currUser.favoriteFeeds.remove(feed.feedId);
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ))
                            : IconButton(
                                onPressed: () {
                                  _currUser.favoriteFeeds.add(feed.feedId);
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
                        Text("  ${feed.comments.length}  "),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.share_rounded,
                        ),
                        Text("  ${feed.sharedUserIds.length}  "),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.bookmark_border_outlined,
                        ),
                        Text("  ${feed.bookmarkedUserIds.length}  "),
                      ],
                    ),
                  ],
                ),
              ),
              Container(child: Text(feed.hashTags)),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Divider()),
              Container(
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
              ),
              Container(
                child: Text("댓글(${feed.comments.length})"),
              )
            ],
          )),
          Positioned(
              bottom: 30,
              child: Container(
                height: 30,
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              _currUser.profileImage)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: mq.size.height / 23,
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                            // controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(60),
                                        bottomLeft: Radius.circular(60)))),
                            onSubmitted: (String value) => {
                                  // showCommentDialog(value)
                                }),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () => {
                          // showCommentDialog(_controller.text)
                        },
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(60),
                            bottomRight: Radius.circular(60)),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(ctx).primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(60),
                                  bottomRight: Radius.circular(60))),
                          height: mq.size.height / 23,
                          child: Center(
                            child: Text(
                              "등록",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: mq.size.width / 20)
                  ],
                ),
              ))
        ]));
  }
}
