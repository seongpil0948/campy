import 'package:campy/views/components/inputs/appbar_text_field.dart';
import 'package:flutter/material.dart';

class PyAppBar extends StatelessWidget {
  const PyAppBar({
    Key? key,
    required this.toolbarH,
  }) : super(key: key);

  final double toolbarH;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarH,
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 25, 0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947_960_720.jpg"),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(toolbarH / 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(height: toolbarH / 4, child: PyAppBarTextField()),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider())
              ],
            ),
          )),
    );
  }
}
