import 'package:campy/components/buttons/avatar.dart';
import 'package:campy/components/buttons/white.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

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
    final sty = TextStyle(
        color: Theme.of(ctx).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 12);
    return PyWhiteButton(
        widget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "포스팅 ${numUserFeeds.toString()}",
          style: sty,
        ),
        TextButton(
          onPressed: () async => showFollow(
              ctx: ctx,
              currUser: currUser,
              users: await currUser.usersByIds(currUser.followers)),
          child: Text(
            "팔로워 ${currUser.followers.length}",
            style: sty,
          ),
        ),
        TextButton(
          onPressed: () async => showFollow(
              ctx: ctx,
              currUser: currUser,
              users: await currUser.usersByIds(currUser.follows)),
          child: Text(
            "팔로우 ${currUser.follows.length}",
            style: sty,
          ),
        )
      ],
    ));
  }
}

void showFollow(
    {required BuildContext ctx,
    required PyUser currUser,
    required List<PyUser> users}) {
  showDialog(
      context: ctx,
      builder: (ctx) => Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height / 2,
            child: ListView.separated(
                itemBuilder: (ctx, idx) => UserList(
                    targetUser: users[idx],
                    currUser: currUser,
                    profileEditable: true),
                separatorBuilder: (ctx, idx) => Divider(),
                itemCount: users.length),
          )));
}

class UserList extends StatelessWidget {
  final PyUser targetUser;
  final PyUser? currUser;
  final bool profileEditable;
  UserList({
    required this.targetUser,
    this.currUser,
    required this.profileEditable,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      leading: PyUserAvatar(
          imgUrl: targetUser.profileImage,
          userId: targetUser.userId,
          profileEditable: profileEditable),
      title: Text(targetUser.displayName ??
          // targetUser.email?.split('@').first ??
          targetUser.email ??
          ""),
      subtitle: Text(targetUser.email ?? ""),
      trailing: profileEditable == true
          ? FollowBtn(
              currUser: currUser!,
              targetUser: targetUser,
            )
          : null,
    );
  }
}

class FollowBtn extends StatefulWidget {
  final PyUser currUser;
  final PyUser targetUser;
  FollowBtn({Key? key, required this.currUser, required this.targetUser})
      : super(key: key);

  @override
  _FollowBtnState createState() => _FollowBtnState();
}

class _FollowBtnState extends State<FollowBtn> {
  Future<void> followUser(PyUser s, PyUser target, bool unFollow) async {
    if (s == target) return;
    setState(() {
      if (unFollow) {
        s.follows.remove(target.userId);
        target.followers.remove(s.userId);
      } else {
        s.follows.add(target.userId);
        target.followers.add(s.userId);
      }
    });
    await s.update();
    await target.update();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.targetUser == widget.currUser) return Container();
    final aleady = widget.targetUser.followers.contains(widget.currUser.userId);
    final txt = aleady ? "팔로우 취소" : "팔로우";
    return ElevatedButton(
        onPressed: () {
          followUser(widget.currUser, widget.targetUser, aleady);
        },
        child: Text(txt));
  }
}

class UserRow extends StatelessWidget {
  const UserRow({
    Key? key,
    required this.feedInfo,
  }) : super(key: key);

  final FeedInfo feedInfo;

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        print("Click User Row");
        final state = ctx.read<PyState>();
        state.selectedUser = feedInfo.writer;
        state.currPageAction = PageAction.my(feedInfo.writer.userId);
      },
      child: Row(
        children: [
          PyUserAvatar(radius: 15, imgUrl: feedInfo.writer.profileImage),
          SizedBox(width: 10),
          Text(
            feedInfo.writer.email ?? "",
            style: Theme.of(ctx).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
