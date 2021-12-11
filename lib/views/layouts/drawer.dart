import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/components/buttons/white.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/models/state.dart';
import 'package:campy/repositories/auth/user.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PyDrawer extends StatelessWidget {
  const PyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final appState = ctx.read<PyState>();
    final tileT = Theme.of(ctx).textTheme.bodyText2;
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        FutureBuilder<CompleteUser>(
            future: getCompleteUser(ctx: ctx),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              final _currUser = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  appState.currPageAction =
                      PageAction.my(_currUser.user.userId);
                },
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(ctx).primaryColor),
                  padding: EdgeInsets.fromLTRB(10, mq.padding.top / 2, 25, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Image(
                              image: AssetImage("assets/images/bell.png"),
                              width: 50,
                              height: 50,
                            ),
                            onPressed: () {},
                          ),
                          Spacer(),
                          Image.asset(
                            'assets/images/logo_w_1.png',
                            fit: BoxFit.contain,
                            height: 60,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 0, 12),
                        child: Text(
                          "Campy",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: CachedNetworkImageProvider(
                                _currUser.user.photoURL),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "@${_currUser.user.displayName ?? _currUser.user.email!.split('@')[0]}",
                                  style: Theme.of(ctx).textTheme.bodyText1,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 7),
                                    height: 23,
                                    child: PyWhiteButton(
                                        widget: Text(
                                      "My Places",
                                      style: TextStyle(
                                          color: Theme.of(ctx).primaryColor),
                                    ))),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 35,
                          child: UserSnsInfo(
                              currUser: _currUser.user,
                              numUserFeeds: _currUser.feeds.length))
                    ],
                  ),
                ),
              );
            }),
        ListTile(
          title: Text("캠핑플레이스", style: tileT),
          onTap: () => appState.currPageAction = PageAction.feed(),
        ),
        ListTile(
          title: Text("스토어", style: tileT),
          onTap: () => appState.currPageAction = PageAction.store(),
        ),
        ListTile(
          title: Text("로그아웃", style: tileT),
          onTap: () => ctx.read<PyAuth>().logout(),
        ),
      ],
    ));
  }
}
