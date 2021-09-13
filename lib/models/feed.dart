import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class FeedInfo {
  const FeedInfo({
    required this.writer,
    required this.isfavorite,
    required this.feedId,
    required this.img,
    required this.content,
    required this.hashTags,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.bookmarkCount,
  });
  final PyUser writer;
  final bool isfavorite;
  final String feedId;
  final String hashTags;
  final ImageProvider img;
  final String content;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int bookmarkCount;
}
