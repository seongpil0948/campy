import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/components/inputs/appbar_text_field.dart';
import 'package:campy/models/state.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/models/user.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PyAppBar extends StatelessWidget {
  const PyAppBar({
    Key? key,
    required this.toolbarH,
  }) : super(key: key);

  final double toolbarH;

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final auth = ctx.watch<PyAuth>();
    return AppBar(
      leading: Container(),
      toolbarHeight: toolbarH,
      flexibleSpace: Padding(
        padding: EdgeInsets.fromLTRB(10, mq.padding.top, 25, 0),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 35,
                ),
                onPressed: () {
                  Scaffold.of(ctx).openDrawer();
                },
                tooltip: MaterialLocalizations.of(ctx).openAppDrawerTooltip,
              ),
              Spacer(),
              FutureBuilder<PyUser>(
                  future: auth.currUser,
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return GestureDetector(
                      onTap: () => {
                        ctx.read<PyState>().currPageAction =
                            PageAction.my(snapshot.data!)
                      },
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            snapshot.data!.profileImage),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(toolbarH / 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(height: toolbarH / 3, child: PyAppBarTextField()),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider())
              ],
            ),
          )),
    );
  }
}
