import 'package:campy/models/common.dart';
import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class Comment {
  ContentType ctype = ContentType.Comment;
  final String id;
  final PyUser writer;
  String content;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  Comment({required this.id, required this.writer, required this.content});

  void update({required String content}) {
    updatedAt = DateTime.now();
    this.content = content;
  }

  Comment.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        writer = PyUser.fromJson(j['writer']),
        ctype = contentTypeFromString(j['ctype']),
        content = j['content'],
        createdAt = j['createdAt'],
        updatedAt = j['updatedAt'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'writer': writer.toJson(),
        'ctype': ctype.toCustomString(),
        'content': content,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
      };
}

class CommentState extends ChangeNotifier {
  Comment? _targetCmt;
  bool _show = false;

  Comment? get getTargetCmt => _targetCmt;

  set setTargetCmt(Comment? cmt) {
    _targetCmt = cmt;
    notifyListeners();
  }

  bool get showPostCmtWidget => _show;

  set showPostCmtWidget(bool to) {
    if (to == false) {
      _targetCmt = null;
    }
    _show = to;
    notifyListeners();
  }
}
