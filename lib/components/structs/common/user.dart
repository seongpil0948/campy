import 'package:campy/components/buttons/white.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class UserSnsInfo extends StatelessWidget {
  const UserSnsInfo({
    Key? key,
    required this.currUser,
    required this.numUserFeeds,
  }) : super(key: key);

  final PyUser currUser;
  final int numUserFeeds;

  @override
  Widget build(BuildContext ctx) {
    return PyWhiteButton(
        widget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i in [
          "포스팅 ${numUserFeeds.toString()}",
          "팔로워 ${currUser.followers.length}",
          "팔로우 ${currUser.follows.length}"
        ])
          Text(
            i,
            style: TextStyle(
                color: Theme.of(ctx).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          )
      ],
    ));
  }
}

class FollowBtn extends StatelessWidget {
  final PyUser currUser;
  final FeedInfo F;
  FollowBtn({Key? key, required this.currUser, required this.F})
      : super(key: key);

  Future<void> followUser(PyUser s, PyUser target, bool unFollow) async {
    if (unFollow) {
      s.follows.remove(target);
      target.followers.remove(s);
    } else {
      s.follows.add(target);
      target.followers.add(s);
    }
    await s.update();
    await target.update();
  }

  @override
  Widget build(BuildContext context) {
    if (F.writer == currUser) return Container();
    final aleady = F.writer.followers.contains(currUser);
    final txt = aleady ? "팔로우 취소" : "팔로우";
    return ElevatedButton(
        onPressed: () {
          followUser(currUser, F.writer, aleady);
        },
        child: Text(txt));
  }
}
