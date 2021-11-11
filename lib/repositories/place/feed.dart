import 'package:campy/models/feed.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/repositories/auth/users.dart';

Future<List<FeedInfo>> getFeeds(Iterable<String> userIds) async {
  List<FeedInfo> allFeeds = [];
  final userC = getCollection(c: Collections.Users);
  for (var _id in userIds) {
    var feeds = await userC
        .doc(_id)
        .collection(FeedCollection)
        .orderBy('createdAt', descending: true)
        .get();
    var feedInfos = feeds.docs.map((f) => FeedInfo.fromJson(f.data()));
    allFeeds.addAll(feedInfos);
  }
  return allFeeds;
}

Future<List<FeedInfo>> getAllFeeds() async {
  final allUsers = await getAllUsers();
  return getFeeds(allUsers.map((u) => u.userId));
}
