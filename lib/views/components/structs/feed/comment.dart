import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/comment.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/sns/comment.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class CommentList extends StatelessWidget {
  const CommentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final comments = ctx.watch<List<Comment>>();
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
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
                            backgroundImage:
                                CachedNetworkImageProvider(c.writer.photoURL)),
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
