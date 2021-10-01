import 'package:campy/models/feed.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:campy/repositories/store/user.dart';

Future<List<FeedInfo>> getFeeds(Iterable<String> userIds) async {
  List<FeedInfo> allFeeds = [];
  final userC = getCollection(Collections.Users);
  for (var _id in userIds) {
    var feeds = await userC.doc(_id).collection("feeds").get();
    print("Get Feeds , user Id: $_id 's Feeds : $feeds");
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
