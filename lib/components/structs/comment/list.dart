import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/comment.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {
  final String feedId;
  final String userId;
  final Stream<QuerySnapshot> commentStream;
  CommentList({Key? key, required this.userId, required this.feedId})
      : commentStream = getCollection(
                c: Collections.Comments, userId: userId, feedId: feedId)
            .snapshots();

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final T = Theme.of(ctx).textTheme;
    return StreamBuilder<QuerySnapshot>(
      stream: widget.commentStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasError &&
            snapshot.connectionState != ConnectionState.waiting) {
          var comments = snapshot.data!.docs
              .map((c) => Comment.fromJson(c.data() as Map<String, dynamic>))
              .toList();
          return Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 34),
                  itemCount: comments.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, idx) {
                    if (idx == 0)
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "댓글 (${comments.length})",
                          style: T.subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    final c = comments[idx];
                    final diffDays = daysBetween(DateTime.now(), c.updatedAt);
                    return Container(
                        width: mq.size.width,
                        height: mq.size.height / 9,
                        child: Row(children: [
                          Column(children: [
                            Row(children: [
                              CircleAvatar(
                                  radius: 15,
                                  backgroundImage: CachedNetworkImageProvider(
                                      c.writer.photoURL)),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(c.writer.email!.split("@")[0],
                                      style: T.bodyText2!.copyWith(
                                          fontWeight: FontWeight.bold))),
                            ])
                          ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    width: mq.size.width / 1.8,
                                    child: Text(c.content,
                                        maxLines: 2)), // TODO: Use Wrap
                                Row(children: [
                                  Consumer<CommentState>(
                                      builder: (ctx, cmtState, child) =>
                                          TextButton(
                                              onPressed: () {
                                                print("답글달기 푸쉬");
                                                cmtState.setTargetCmt = c;
                                                cmtState.showPostCmtWidget =
                                                    true;
                                              },
                                              child: Text(
                                                // TODO: Implement Reply List Use Wrap
                                                "답글달기",
                                                style: T.bodyText2!.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ))),
                                  Text("${diffDays.abs()}일전")
                                ])
                              ])
                        ]));
                  }),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
