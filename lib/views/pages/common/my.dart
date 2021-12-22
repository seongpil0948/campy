import 'package:campy/components/buttons/avatar.dart';
import 'package:campy/components/buttons/fabs.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/components/structs/feed/list.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/user.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports

class MyView extends StatelessWidget {
  final PyUser? selectedUser;
  const MyView({Key? key, this.selectedUser}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final body = FutureBuilder<CompleteUser>(
      future: getCompleteUser(ctx: ctx, selectedUser: selectedUser),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final _currUser = snapshot.data!;
        return _MyViewW(currUser: _currUser);
      },
    );
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FeedFab(),
        drawer: PyDrawer(),
        body: ctx.watch<PyState>().isLoading
            ? Stack(
                children: [body, Center(child: CircularProgressIndicator())],
              )
            : body);
  }
}

class _MyViewW extends StatelessWidget {
  const _MyViewW({
    Key? key,
    required CompleteUser currUser,
  })  : _currUser = currUser,
        super(key: key);

  final CompleteUser _currUser;

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);

    return Column(children: [
      Container(
        height: mq.size.height / 2.3,
        width: mq.size.width,
        child: Stack(children: [
          Image.asset(
            "assets/images/splash_back_1.png",
            width: mq.size.width,
            fit: BoxFit.cover,
          ),
          Opacity(
              opacity: 0.4,
              child: Container(color: Theme.of(ctx).primaryColor)),
          Container(
            width: mq.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                PyUserAvatar(
                    imgUrl: _currUser.user.profileImage,
                    radius: 40,
                    profileEditable: true,
                    userId: _currUser.user.userId),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "@${_currUser.user.email!.split('@')[0]}",
                    style: Theme.of(ctx).textTheme.bodyText1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  width: mq.size.width / 1.5,
                  child: UserSnsInfo(
                      currUser: _currUser.user,
                      numUserFeeds: _currUser.feeds.length),
                ),
                Text("이 시대 진정한 인싸 캠핑러 \n 정보 공유 DM 환영 ",
                    style: Theme.of(ctx).textTheme.bodyText1),
              ],
            ),
          )
        ]),
      ),
      Container(
          height: mq.size.height - (mq.size.height / 2.3),
          child: Stack(
            children: [
              GridFeeds(
                  feeds: _currUser.feeds, mq: mq, currUser: _currUser.user),
            ],
          ))
    ]);
  }
}
