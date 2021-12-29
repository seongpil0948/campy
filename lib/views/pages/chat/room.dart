import 'package:campy/components/buttons/avatar.dart';
import 'package:campy/models/chat.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatelessWidget {
  final PyUser targetUser;
  final PyUser currUser;
  final String roomId;

  ChatRoom(
      {Key? key,
      required this.roomId,
      required this.targetUser,
      required this.currUser})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final s = MediaQuery.of(ctx).size;
    return Container(
        width: s.width + 30,
        height: s.height,
        child: Column(
          children: [
            ChatRoomHeader(s: s, targetUser: targetUser),
            Expanded(
              child: ChatRoomBody(roomId: roomId, currUser: currUser),
            ),
            ChatTextField(chatRoomId: roomId, currUser: currUser)
          ],
        ));
  }
}

class ChatRoomBody extends StatelessWidget {
  const ChatRoomBody({
    Key? key,
    required this.roomId,
    required this.currUser,
  }) : super(key: key);

  final String roomId;
  final PyUser currUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getCollection(c: Collections.Messages, roomId: roomId)
            .orderBy("createdAt")
            .limit(30)
            .snapshots(),
        builder: (BuildContext ctx2, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final msgs = snapshot.data!.docs
              .map((m) => Msg.fromJson(m.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
              itemCount: msgs.length,
              itemBuilder: (ctx, idx) {
                final msg = msgs[idx];
                return ChatW(msg: msg, fromMe: currUser == msg.writer);
              });
        });
  }
}

class ChatRoomHeader extends StatelessWidget {
  const ChatRoomHeader({
    Key? key,
    required this.s,
    required this.targetUser,
  }) : super(key: key);

  final Size s;
  final PyUser targetUser;

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: s.width,
      height: s.height / 12,
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.0))),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              icon: Icon(Icons.backspace)),
          GoMyAvatar(user: targetUser),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(targetUser.displayName ?? ""),
                Text(targetUser.email ?? "")
              ],
            ),
          )
        ],
      ),
    );
  }
}

const u = Uuid();

class ChatTextField extends StatelessWidget {
  final TextEditingController txtController = TextEditingController();
  final String chatRoomId;
  final PyUser currUser;
  ChatTextField({Key? key, required this.chatRoomId, required this.currUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: txtController,
          minLines: 1,
          maxLines: 12,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    getCollection(c: Collections.Messages, roomId: chatRoomId)
                        .doc()
                        .set(Msg(
                                id: u.v4(),
                                writer: currUser,
                                content: txtController.text)
                            .toJson());
                    txtController.clear();
                  },
                  icon: Icon(Icons.send)))),
    );
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment:
            fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (fromMe == false) ...[
            GoMyAvatar(user: msg.writer),
            SizedBox(width: 5)
          ],
          Text(msg.content)
        ],
      ),
    );
  }
}
