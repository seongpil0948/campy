import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:campy/views/components/buttons/fabs.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

  Future<List<FeedInfo>> getFeeds(List<String> userIds) async {
    List<FeedInfo> allFeeds = [];
    final userC = getCollection(Collections.Users);
    for (var _id in userIds) {
      var feeds = await userC.doc(_id).collection("feeds").get();
      var feedInfos = feeds.docs.map((f) => FeedInfo.fromJson(f.data()));
      allFeeds.addAll(feedInfos);
    }
    return allFeeds;
  }

  @override
  Widget build(BuildContext ctx) {
    final _usersStream = getCollection(Collections.Users).snapshots();
    // .then((user) => user.docs.map((x) => x.data()));
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
                      children: feedSnapshot.data!
                          .map((feedInfo) => ListTile(
                                title: Text(" >>> \n $feedInfo \n <<<"),
                              ))
                          .toList(),
                    );
                  });
            }));
  }
}

class PyFeedList extends StatelessWidget {
  const PyFeedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
