import 'package:campy/models/user.dart';

import 'common.dart';

class Comment with PyDateMixin {
  final PyUser writer;
  final List<Comment> reply = [];
  final ContentType ctype;
  String content;

  Comment({required this.writer, required this.content, required this.ctype});

  void update({required String content}) {
    this.content = content;
    updateTime();
  }
}
