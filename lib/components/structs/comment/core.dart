import 'package:campy/components/structs/comment/list.dart';
import 'package:campy/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentW extends StatelessWidget {
  const CommentW({
    Key? key,
    required this.mq,
    required this.c,
    required this.diffDays,
  }) : super(key: key);

  final MediaQueryData mq;
  final Comment c;
  final int diffDays;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Column(children: [AvartarIdRow(c: c)]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Text(c.content)),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(children: [
                Text("${diffDays.abs()}일전"),
                Consumer<CommentState>(
                    builder: (ctx, cmtState, child) => TextButton(
                        onPressed: () {
                          cmtState.setTargetCmt = c;
                          cmtState.showPostCmtWidget = true;
                        },
                        child: Text("답글달기",
                            style: Theme.of(ctx)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis)))
              ]),
            ),
            // ReplyList(c: c, feedId: widget.feedId)
          ],
        ),
      ])
    ]);
  }
}
