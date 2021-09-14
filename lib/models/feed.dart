import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedInfo {
  const FeedInfo({
    required this.writer,
    required this.isfavorite,
    required this.feedId,
    required this.files,
    required this.content,
    required this.hashTags,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.bookmarkCount,
  });
  final PyUser writer;
  final bool isfavorite;
  final String? feedId;
  final String hashTags;
  final List<XFile> files;
  final String content;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int bookmarkCount;

  FeedInfo.fromJson(Map<String, dynamic> j)
      : writer = PyUser.fromJson(j),
        isfavorite = j['isfavorite'],
        feedId = j['id'],
        files = j['files'],
        content = j['content'],
        hashTags = j['hashTags'],
        likeCount = j['likeCount'],
        commentCount = j['commentCount'],
        shareCount = j['shareCount'],
        bookmarkCount = j['bookmarkCount'];

  Map<String, dynamic> toJson() => {
        'writer': writer.toJson(),
        'isfavorite': isfavorite,
        'feedId': feedId,
        'files': files,
        'content': content,
        'hashTags': hashTags,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'bookmarkCount': bookmarkCount,
      };
}
