import 'package:campy/models/user.dart';

import 'common.dart';

class Comment with PyDateMixin {
  final String commentId;
  final PyUser writer;
  final ContentType ctype;
  List<Comment> replies = [];
  String content;

  Comment(
      {required this.commentId,
      required this.writer,
      required this.content,
      required this.ctype});

  void update({required String content}) {
    this.content = content;
    updateTime();
  }

  // FIXME: 현재 받아올때마다 DocumentID를 함께 가져오긴 하지만 이건 문제가 있다.
  Comment.fromJson(Map<String, dynamic> j, this.commentId)
      : writer = PyUser.fromJson(j['writer']),
        replies = j['replies'].map<Comment>(
            (Map<String, dynamic> c) => Comment.fromJson(c, c['commentId'])),
        ctype = contentTypeFromString(j['ctype']),
        content = j['content'];

  Map<String, dynamic> toJson() => {
        'writer': writer.toJson(),
        'replies': replies.map((r) => r.toJson()).toList(),
        'ctype': ctype.toCustomString(),
        'content': content,
      };
}
