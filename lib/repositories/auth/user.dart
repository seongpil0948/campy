import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/place/feed.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class CompleteUser {
  PyUser user;
  List<FeedInfo> feeds;
  CompleteUser({required this.user, required this.feeds});
}

Future<CompleteUser> getCompleteUser(
    {required BuildContext ctx, PyUser? selectedUser}) async {
  final user = selectedUser ?? await ctx.watch<PyAuth>().currUser;
  final feeds = await getFeeds([user.userId]);
  return CompleteUser(feeds: feeds, user: user);
}
