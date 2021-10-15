import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/state.dart';
import 'package:campy/views/components/buttons/white.dart';
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
    print("Drawer AppState");
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Expanded(
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
                          "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947_960_720.jpg"),
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
                            "USER NAME",
                            style: Theme.of(ctx).textTheme.overline,
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
                    child: PyWhiteButton(
                        widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i in ["포스팅 4", "팔로워 3,130", "팔로우 3,130"])
                          Text(
                            i,
                            style: TextStyle(
                                color: Theme.of(ctx).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          )
                      ],
                    )))
              ],
            ),
          ),
        ),
        ListTile(
          title: Text(
            "캠핑플레이스",
            style: Theme.of(ctx).textTheme.bodyText2,
          ),
          onTap: () => appState.currPageAction = PageAction.feed(),
        ),
        ListTile(
          title: Text(
            "스토어",
            style: Theme.of(ctx).textTheme.bodyText2,
          ),
          onTap: () => appState.currPageAction = PageAction.store(),
        ),
      ],
    ));
  }
}
