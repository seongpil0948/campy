import 'package:campy/models/common.dart';
import 'package:campy/models/reply.dart';
import 'package:campy/models/user.dart';

class Comment extends Reply {
  ContentType ctype = ContentType.Comment;
  // List<Reply> replies = [];
  Comment({required String id, required PyUser writer, required String content})
      : super(id: id, writer: writer, content: content);

  Comment.fromJson(Map<String, dynamic> j)
      // : replies = j['replies']
      //       .map<Reply>((Map<String, dynamic> c) => Reply.fromJson(c))
      //       .toList(),
      : super.fromJson(j);

  Map<String, dynamic> toJson() {
    var j = super.toJson();
    // j['replies'] = replies.map((r) => r.toJson()).toList();
    return j;
  }
}
