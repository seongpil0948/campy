import 'package:campy/components/buttons/white.dart';
import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class UserSnsInfo extends StatelessWidget {
  const UserSnsInfo({
    Key? key,
    required PyUser currUser,
  })  : _currUser = currUser,
        super(key: key);

  final PyUser _currUser;

  @override
  Widget build(BuildContext ctx) {
    return PyWhiteButton(
        widget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i in [
          "포스팅 ${_currUser.feeds.length}",
          "팔로워 ${_currUser.followers.length}",
          "팔로우 ${_currUser.follows.length}"
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
