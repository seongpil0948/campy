import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/auth/users.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/views/pages/chat/room.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
              itemBuilder: (ctx, idx) {
                final roomIds = (currUser.userId + users[idx].userId).split("");
                roomIds.sort();
                final roomId = roomIds.join();
                return Slidable(
                  child: InkWell(
                    onTap: () {
                      showGeneralDialog(
                          context: ctx,
                          pageBuilder: (BuildContext ctx2, Animation animation,
                                  Animation secondaryAnimation) =>
                              Scaffold(
                                body: SafeArea(
                                  child: ChatRoom(
                                    roomId: roomId,
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
                        onPressed: (ctx) {
                          try {
                            getCollection(c: Collections.Messages)
                                .doc(roomId)
                                .delete();
                          } catch (e) {
                            FirebaseCrashlytics.instance
                                .recordError(e, null, reason: 'a fatal error');
                          }
                        },
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '삭제하기',
                      ),
                    ],
                  ),
                );
              },
              itemCount: users.length);
        });
  }
}
