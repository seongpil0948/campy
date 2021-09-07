import 'package:campy/config.dart';
import 'package:campy/models/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PyUser {
  final User socialUser;
  String get profileImage => socialUser.photoURL ?? PyDefault.profileImage;
  List<FeedInfo> feeds = [];
  List<PyUser> followers = [];
  List<PyUser> follows = [];
  PyUser({required this.socialUser});

  @override
  String toString() {
    return "PyUser: Social: $socialUser \n feeds: $feeds \n followers: $followers \n follows: $follows";
  }
}
