import 'package:campy/components/buttons/avatar.dart';
import 'package:campy/models/comment.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/sns/comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final target = Provider.of<CommentState>(ctx).getTargetCmt;
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
              child: PyUserAvatar(radius: 17, imgUrl: _currUser.profileImage),
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
                          _submit(target, _commentController.text, _currUser,
                              feed, ctx, _commentController);
                        },
                        icon: Icon(Icons.send),
                        iconSize: 18,
                        color: Theme.of(ctx).primaryColor),
                  ),
                  onSubmitted: (String txt) {
                    _submit(
                        target, txt, _currUser, feed, ctx, _commentController);
                  })),
        ],
      ),
    );
  }
}

void _submit(Comment? target, String txt, PyUser user, FeedInfo feed,
    BuildContext ctx, TextEditingController _commentController) {
  target == null
      ? postComment(txt, user, feed)
      : postReply(txt, user, feed.feedId, target.id);
  _commentController.clear();
  Provider.of<CommentState>(ctx, listen: false).showPostCmtWidget = false;
}
