import 'package:campy/components/buttons/avatar.dart';
import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/auth/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ChatCategoryView extends StatelessWidget {
  const ChatCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Pyffold(body: Container(child: ChatRoomList()));
  }
}

class ChatRoomList extends StatelessWidget {
  const ChatRoomList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return FutureBuilder<List<dynamic>>(
        future: Future.wait([getAllUsers(), ctx.watch<PyAuth>().currUser]),
        initialData: [],
        builder: (ctx, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final PyUser currUser = snapshot.data![1];
          final List<PyUser> users =
              snapshot.data![0].where((e) => e != currUser).toList();
          return ListView.separated(
              itemBuilder: (ctx, idx) =>
                  UserList(targetUser: users[idx], profileEditable: false),
              separatorBuilder: (ctx, idx) => Divider(),
              itemCount: users.length);
        });
  }
}
