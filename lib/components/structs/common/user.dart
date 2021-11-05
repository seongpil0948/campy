import 'package:campy/components/buttons/white.dart';
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
