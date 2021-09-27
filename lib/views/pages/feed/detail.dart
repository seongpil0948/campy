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
    final iconSize = {'width': 15.0, 'height': 15.0};
    return Scaffold(
        drawer: PyDrawer(),
        body: SingleChildScrollView(
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
                                if (feed.feedId != null)
                                  _currUser.favoriteFeeds.add(feed.feedId!);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ))
                          : IconButton(
                              onPressed: () {
                                if (feed.feedId != null)
                                  _currUser.favoriteFeeds.add(feed.feedId!);
                              },
                              icon: Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.black,
                              ),
                            ),
                      Text("  ${feed.likeCount.toString()}  "),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/imgs/comment_icon.png"),
                        width: iconSize['width'],
                        height: iconSize['heihgt'],
                      ),
                      Text("  ${feed.commentCount.toString()}  "),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.share_rounded,
                      ),
                      Text("  ${feed.shareCount.toString()}  "),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.bookmark_border_outlined,
                      ),
                      Text("  ${feed.bookmarkCount.toString()}  "),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
