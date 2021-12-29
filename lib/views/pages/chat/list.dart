import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/auth/users.dart';
import 'package:campy/views/pages/chat/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: implementation_imports
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
          if (!snapshot.hasData || snapshot.data!.length < 1)
            return Center(child: CircularProgressIndicator());

          final PyUser currUser = snapshot.data![1];
          final List<PyUser> users =
              snapshot.data![0].where((e) => e != currUser).toList();
          return ListView.builder(
              itemBuilder: (ctx, idx) => Slidable(
                    child: InkWell(
                      onTap: () {
                        showGeneralDialog(
                            context: ctx,
                            pageBuilder: (BuildContext ctx2,
                                    Animation animation,
                                    Animation secondaryAnimation) =>
                                Scaffold(
                                  body: SafeArea(
                                    child: ChatRoom(
                                      targetUser: users[idx],
                                      currUser: currUser,
                                    ),
                                  ),
                                ));
                      },
                      child: UserList(
                          targetUser: users[idx], profileEditable: false),
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          key: ValueKey("1"),
                          // flex: 2,
                          onPressed: (ctx) {},
                          backgroundColor: Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: Icons.archive,
                          label: 'Archive',
                        ),
                        SlidableAction(
                          key: ValueKey("2"),
                          onPressed: (ctx) {},
                          backgroundColor: Color(0xFF0392CF),
                          foregroundColor: Colors.white,
                          icon: Icons.save,
                          label: 'Save',
                        ),
                      ],
                    ),
                  ),
              itemCount: users.length);
        });
  }
}
