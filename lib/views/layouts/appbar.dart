import 'package:campy/providers/auth.dart';
import 'package:campy/views/components/inputs/appbar_text_field.dart';
import 'package:flutter/material.dart';
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
        padding: EdgeInsets.fromLTRB(10, mq.padding.top / 2, 25, 0),
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
            CircleAvatar(
              backgroundImage: NetworkImage(auth.currUser != null
                  ? auth.currUser!.profileImage
                  : "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947_960_720.jpg"),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(toolbarH / 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(height: toolbarH / 2.5, child: PyAppBarTextField()),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider())
              ],
            ),
          )),
    );
  }
}
