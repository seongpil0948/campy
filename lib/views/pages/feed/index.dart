import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:campy/views/components/buttons/fabs.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/router/path.dart';
import 'package:campy/views/utils/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

  Future<List<FeedInfo>> getFeeds(List<String> userIds) async {
    List<FeedInfo> allFeeds = [];
    final userC = getCollection(Collections.Users);
    for (var _id in userIds) {
      var feeds = await userC.doc(_id).collection("feeds").get();
      var feedInfos = feeds.docs.map((f) => FeedInfo.fromJson(f.data(), f.id));
      allFeeds.addAll(feedInfos);
    }
    return allFeeds;
  }

  @override
  Widget build(BuildContext ctx) {
    final _usersStream = getCollection(Collections.Users).snapshots();
    final mq = MediaQuery.of(ctx);
    return Pyffold(
        fButton: FeedFab(),
        body: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext ctx1, AsyncSnapshot<QuerySnapshot> userSnapShot) {
              if (userSnapShot.hasError) {
                return Text('Something went wrong of Users');
              } else if (userSnapShot.connectionState ==
                  ConnectionState.waiting) {
                return Text("Loading of Users");
              }
              final users = userSnapShot.data!.docs.map((userDoc) =>
                  PyUser.fromJson(userDoc.data()! as Map<String, dynamic>));

              return FutureBuilder(
                  future: getFeeds(users.map((u) => u.userId).toList()),
                  builder: (BuildContext ctx2,
                      AsyncSnapshot<List<FeedInfo>> feedSnapshot) {
                    if (feedSnapshot.hasError) {
                      return Text('Something went wrong of Feeds');
                    } else if (feedSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text("Loading of Feeds");
                    }
                    return ListView(
                      children: feedSnapshot.data!.map((feedInfo) {
                        final imgs = feedInfo.files.where((f) =>
                            f.ftype == PyFileType.Image && f.url != null);

                        return GestureDetector(
                          onTap: () {
                            ctx2.read<PyState>().currPageAction =
                                PageAction.feedDetail(feedInfo.feedId);
                          },
                          child: Container(
                            margin: EdgeInsets.all(20),
                            height: mq.size.height / 3,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Stack(children: [
                                  CachedNetworkImage(
                                      // FIXME: 동영상일때는 썸네일을 보여줄 수 있도록
                                      fit: BoxFit.fill,
                                      width: mq.size.width,
                                      imageUrl: imgs.length > 0
                                          ? imgs.first.url!
                                          : feedInfo.writer.photoURL),
                                  Positioned(
                                      bottom: mq.size.height / 30,
                                      left: mq.size.width / 15,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                  radius: 15,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          feedInfo.writer
                                                              .photoURL)),
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
                                              style: Theme.of(ctx2)
                                                  .textTheme
                                                  .headline3
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                          Text(feedInfo.hashTags
                                              .replaceAll(" ", " #"))
                                        ],
                                      ))
                                ])),
                          ),
                        );
                      }).toList(),
                    );
                  });
            }));
  }
}
