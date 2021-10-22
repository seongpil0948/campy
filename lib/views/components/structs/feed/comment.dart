import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/comment.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/repositories/sns/comment.dart';
import 'package:campy/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                                    child: Text(c.content, maxLines: 2)),
                                Row(children: [
                                  TextButton(
                                      onPressed: () {
                                        print("답글달기 푸쉬");
                                      },
                                      child: Text(
                                        "답글달기",
                                        style: T.bodyText2!.copyWith(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      )),
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

class CommentPost extends StatelessWidget {
  const CommentPost(
      {Key? key,
      required this.mq,
      required PyUser currUser,
      required TextEditingController commentController,
      required this.feed})
      : _currUser = currUser,
        _commentController = commentController,
        super(key: key);

  final MediaQueryData mq;
  final PyUser _currUser;
  final TextEditingController _commentController;
  final FeedInfo feed;

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: mq.size.width - 40,
      margin: EdgeInsets.only(left: 20),
      decoration: new BoxDecoration(
        color: Theme.of(ctx).primaryColor,
        border: Border.all(color: Colors.black, width: 0.0),
        borderRadius: const BorderRadius.all(Radius.circular(60)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: CircleAvatar(
                  radius: 17,
                  backgroundImage:
                      CachedNetworkImageProvider(_currUser.profileImage)),
            ),
          ),
          Expanded(
              flex: 6,
              child: TextField(
                  controller: _commentController,
                  minLines: 1,
                  maxLines: 12,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                        onPressed: () {
                          postComment(_commentController.text, _currUser, feed);
                          _commentController.clear();
                        },
                        icon: Icon(Icons.send),
                        iconSize: 18,
                        color: Theme.of(ctx).primaryColor),
                  ),
                  onSubmitted: (String txt) =>
                      postComment(txt, _currUser, feed))),
        ],
      ),
    );
  }
}
