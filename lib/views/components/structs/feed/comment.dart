import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/comment.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/repositories/sns/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class CommentList extends StatefulWidget {
  final String feedId;
  final String userId;
  Stream<QuerySnapshot> commentStream;
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
                  itemCount: comments.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, idx) {
                    if (idx == 0) return Text("댓글 ${comments.length}");
                    final c = comments[idx];
                    return Container(
                      height: mq.size.height / 10,
                      width: mq.size.width,
                      child: Container(
                          width: mq.size.width,
                          height: mq.size.height / 10,
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 15,
                                  backgroundImage: CachedNetworkImageProvider(
                                      c.writer.photoURL)),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(c.writer.email!.split("@")[0])),
                              Expanded(child: Text(c.content))
                            ],
                          )),
                    );
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
