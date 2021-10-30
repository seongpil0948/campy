import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/components/buttons/fabs.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/components/structs/feed/feed.dart';
import 'package:campy/models/auth.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/utils/feed.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class MyView extends StatelessWidget {
  const MyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FeedFab(),
        drawer: PyDrawer(),
        body: FutureBuilder<PyUser>(
          future: ctx.watch<PyAuth>().currUser,
          builder: (ctx, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            final _currUser = snapshot.data!;
            return Column(children: [
              Container(
                height: mq.size.height / 2.3,
                width: mq.size.width,
                child: Stack(children: [
                  Image.asset(
                    "assets/images/splash_back_1.png",
                    width: mq.size.width,
                    fit: BoxFit.cover,
                  ),
                  Opacity(
                      opacity: 0.4,
                      child: Container(color: Theme.of(ctx).primaryColor)),
                  Container(
                    width: mq.size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        CircleAvatar(
                            radius: 40,
                            backgroundImage: CachedNetworkImageProvider(
                                _currUser.profileImage)),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "@${_currUser.email!.split('@')[0]}",
                            style: Theme.of(ctx).textTheme.bodyText1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          width: mq.size.width / 1.5,
                          child: UserSnsInfo(currUser: _currUser),
                        ),
                        Text("이 시대 진정한 인싸 캠핑러 \n 정보 공유 DM 환영 ",
                            style: Theme.of(ctx).textTheme.bodyText1),
                      ],
                    ),
                  )
                ]),
              ),
              Container(
                  height: mq.size.height - (mq.size.height / 2.3),
                  child: Stack(
                    children: [
                      _GridFeeds(
                          feeds: _currUser.feeds, mq: mq, currUser: _currUser),
                    ],
                  ))
            ]);
          },
        ));
  }
}

class _GridFeeds extends StatelessWidget {
  const _GridFeeds({
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
                        child: FeedStatusRow(currUser: _currUser, feed: f)),
                    Expanded(
                      flex: 3,
                      child: FeedThumnail(
                          mq: mq, imgs: imgsOfFeed(f), feedInfo: f),
                    )
                  ],
                ),
              ));
        });
  }
}
