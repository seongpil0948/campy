import 'package:campy/models/common.dart';
import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class Comment with PyDateMixin {
  ContentType ctype = ContentType.Comment;
  final String id;
  final PyUser writer;
  String content;
  Comment({required this.id, required this.writer, required this.content});

  void update({required String content}) {
    this.content = content;
    updateTime();
  }

  Comment.fromJson(Map<String, dynamic> j)
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
