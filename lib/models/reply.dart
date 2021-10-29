import 'package:campy/models/comment.dart';
import 'package:campy/models/user.dart';

import 'common.dart';

class Reply extends Comment {
  ContentType ctype = ContentType.Reply;
  final String targetCmtId;
  Reply(
      {required this.targetCmtId,
      required String id,
      required PyUser writer,
      required String content})
      : super(id: id, writer: writer, content: content);

  Reply.fromJson(Map<String, dynamic> j)
      : targetCmtId = j['targetCmtId'],
        super(
            content: j['content'],
            writer: PyUser.fromJson(j['writer']),
            id: j['id']);

  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j['targetCmtId'] = targetCmtId;
    return j;
  }
}
