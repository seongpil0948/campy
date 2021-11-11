import 'package:campy/components/assets/carousel.dart';
import 'package:campy/components/structs/comment/list.dart';
import 'package:campy/components/structs/comment/post.dart';
import 'package:campy/components/structs/feed/feed.dart';
import 'package:campy/components/structs/place/place.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/models/comment.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/utils/parsers.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class FeedDetailView extends StatelessWidget {
  FeedDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final state = ctx.read<PyState>();
    final feed = state.selectedFeed!;
    var _commentController = TextEditingController();
    return Scaffold(
        drawer: PyDrawer(),
        body: ChangeNotifierProvider<CommentState>(
            create: (ctx) => CommentState(),
            child: FutureBuilder<PyUser>(
                future: ctx.watch<PyAuth>().currUser,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return FeedDetailW(
                      mq: mq,
                      feed: feed,
                      currUser: snapshot.data!,
                      commentController: _commentController);
                })));
  }
}

class FeedDetailW extends StatelessWidget {
  const FeedDetailW({
    Key? key,
    required this.mq,
    required this.feed,
    required PyUser currUser,
    required TextEditingController commentController,
  })  : _currUser = currUser,
        _commentController = commentController,
        super(key: key);

  final MediaQueryData mq;
  final FeedInfo feed;
  final PyUser _currUser;
  final TextEditingController _commentController;

  @override
  Widget build(BuildContext ctx) {
    const leftPadding = 20.0;
    const iconImgH = 24.0;
    Map<String, Text> tagMap = {};
    feed.hashTags
        .forEach((tag) => tagMap[tag] = Text(tag, style: tagTextSty(tag, ctx)));
    return Stack(children: [
      SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            Provider.of<CommentState>(ctx, listen: false).showPostCmtWidget =
                false;
          },
          child: Column(
            children: [
              Container(
                  width: mq.size.width,
                  height: mq.size.height / 2,
                  child: PyCarousel(fs: feed.files)),
              Container(
                width: mq.size.width * 0.6,
                padding: EdgeInsets.only(left: leftPadding),
                margin: EdgeInsets.symmetric(vertical: mq.size.height / 100),
                child: FeedStatusRow(currUser: _currUser, feed: feed),
              ),
              if (feed.hashTags.length > 0) ...[
                _Divider(),
                Wrap(
                  runSpacing: 10.0,
                  spacing: 10.0,
                  children:
                      feed.hashTags.map<Widget>((tag) => tagMap[tag]!).toList(),
                )
              ],
              _Divider(),
              PlaceInfo(mq: mq, iconImgH: iconImgH),
              RichText(
                  text: TextSpan(
                      children: feed.content
                          .split(
                              ' ') /*find words that start with '@' and include a username that can also be found in the list of mentions*/
                          .map((word) => TextSpan(
                                text: word + ' ',
                                style: tagMap.containsKey(word)
                                    ? tagMap[word]!.style
                                    : Theme.of(ctx).textTheme.bodyText2,
                              ))
                          .toList())),
              _Divider(),
              Consumer<CommentState>(
                  builder: (ctx, cmtState, child) => TextButton(
                      onPressed: () {
                        cmtState.setTargetCmt = null;
                        cmtState.showPostCmtWidget = true;
                      },
                      child: Text("댓글 달기"))),
              Padding(
                padding: const EdgeInsets.only(left: leftPadding),
                child:
                    CommentList(feedId: feed.feedId, userId: _currUser.userId),
              )
            ],
          ),
        ),
      ),
      if (Provider.of<CommentState>(ctx).showPostCmtWidget)
        Positioned(
          bottom: 30,
          child: CommentPost(
            mq: mq,
            currUser: _currUser,
            commentController: _commentController,
            feed: feed,
          ),
        )
    ]);
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Divider());
  }
}
