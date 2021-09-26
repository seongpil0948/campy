import 'package:campy/models/user.dart';

// TODO: DateTime
// TODO: DateTime apply to other models

enum ContentType { Feed, Store, Comment }

class Comment {
  final PyUser writer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final List<Comment> reply = [];
  final ContentType ctype;

  Comment(
      {required this.writer,
      required this.createdAt,
      required this.updatedAt,
      required this.content,
      required this.ctype});
}
