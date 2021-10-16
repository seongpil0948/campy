import 'package:campy/models/feed.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/repositories/auth/user.dart';

Future<List<FeedInfo>> getFeeds(Iterable<String> userIds) async {
  List<FeedInfo> allFeeds = [];
  final userC = getCollection(c: Collections.Users);
  for (var _id in userIds) {
    var feeds = await userC.doc(_id).collection("feeds").get();
    var feedInfos = feeds.docs.map((f) => FeedInfo.fromJson(f.data(), f.id));
    allFeeds.addAll(feedInfos);
  }
  return allFeeds;
}

Future<List<FeedInfo>> getAllFeeds() async {
  final allUsers = await getAllUsers();
  print("Get All Feeds , user datas: $allUsers");
  return getFeeds(allUsers.map((u) => u.userId));
}
