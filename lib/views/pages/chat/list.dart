import 'package:campy/components/buttons/avatar.dart';
import 'package:campy/components/buttons/pyffold.dart';
import 'package:campy/components/structs/common/user.dart';
import 'package:campy/models/chat.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/auth/users.dart';
import 'package:campy/repositories/init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

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
                        showDialog(
                            context: ctx,
                            builder: (ctx2) {
                              return Dialog(child: ChatRoom());
                            });
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

class ChatRoom extends StatelessWidget {
  final String? chatRoomId;
  const ChatRoom({Key? key, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final s = MediaQuery.of(ctx).size;
    final roomId = chatRoomId == null ? Uuid().v4() : chatRoomId!;
    return Container(
        width: s.width,
        height: s.height,
        child: Column(
          children: [
            Container(
              // * Header
              width: s.width,
              height: s.height / 12,
              child: Row(
                children: [Text("Header")],
              ),
            ),
            Expanded(
              // * Body
              child: StreamBuilder<QuerySnapshot>(
                  stream: getCollection(c: Collections.Messages)
                      .doc(roomId)
                      .collection(roomId)
                      .orderBy("createdAt", descending: true)
                      .limit(30)
                      .snapshots(),
                  builder: (BuildContext ctx2,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final msgs = snapshot.data!.docs
                        .map((m) => Msg.fromJson(m as Map<String, dynamic>))
                        .toList();
                    msgs.addAll(mockMsgs);

                    return ListView.builder(
                        itemCount: msgs.length,
                        itemBuilder: (ctx, idx) {
                          final msg = msgs[idx];
                          return Text(msg.content);
                        });
                  }),
            ),
            Wrap(// * Footer
                children: [
              Row(
                children: [Text("Footer")],
              )
            ])
          ],
        ));
  }
}

class ChatW extends StatelessWidget {
  final Msg msg;
  final bool fromMe;
  const ChatW({Key? key, required this.msg, required this.fromMe})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final s = MediaQuery.of(ctx).size;
    return Container(
      height: 40,
      width: s.width / 2,
      child: Row(
        children: [
          if (fromMe == true) GoMyAvatar(user: msg.writer),
          Text(msg.content)
        ],
      ),
    );
  }
}

final mockMsgs = Msg.mocks(20);
