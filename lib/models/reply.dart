import 'package:campy/models/user.dart';

import 'common.dart';

class Reply with PyDateMixin {
  ContentType ctype = ContentType.Reply;
  final String id;
  final PyUser writer;
  String content;

  Reply({required this.id, required this.writer, required this.content});

  void update({required String content}) {
    this.content = content;
    updateTime();
  }

  Reply.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        writer = PyUser.fromJson(j['writer']),
        ctype = contentTypeFromString(j['ctype']),
        content = j['content'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'writer': writer.toJson(),
        'ctype': ctype.toCustomString(),
        'content': content,
      };
}
