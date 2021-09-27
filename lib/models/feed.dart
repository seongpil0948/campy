import 'package:campy/models/user.dart';
import 'package:campy/utils/io.dart';

import 'common.dart';

// TODO: count to object
class FeedInfo with PyDateMixin {
  FeedInfo(
      {required this.writer,
      required this.isfavorite,
      required this.feedId,
      required this.files,
      required this.title,
      required this.content,
      required this.placeAround,
      required this.placePrice,
      required this.campKind,
      required List<String> hashTags})
      : hashTags = hashTags.join(" ");
  final PyUser writer;
  final bool isfavorite;
  final String? feedId;
  final List<PyFile> files;
  final String title;
  final String content;
  final String placeAround;
  final int placePrice;
  final String campKind;

  String hashTags;
  int likeCount = 0;
  int commentCount = 0;
  int shareCount = 0;
  int bookmarkCount = 0;

  @override
  String toString() {
    return "\n >>>>> User: $writer 's FeedInfo: \n Title$title \n tags: $hashTags \n Files: $files \n <<<<<";
  }

  FeedInfo.fromJson(Map<String, dynamic> j, String documentId)
      : writer = PyUser.fromJson(j['writer']),
        isfavorite = j['isfavorite'],
        feedId = documentId,
        files = j['files'].map<PyFile>((f) => PyFile.fromJson(f)).toList(),
        title = j['title'],
        content = j['content'],
        placeAround = j['placeAround'],
        placePrice = j['placePrice'],
        campKind = j['campKind'],
        hashTags = j['hashTags'],
        likeCount = j['likeCount'] ?? 0,
        commentCount = j['commentCount'] ?? 0,
        shareCount = j['shareCount'] ?? 0,
        bookmarkCount = j['bookmarkCount'] ?? 0;

  Map<String, dynamic> toJson() => {
        'writer': writer.toJson(),
        'isfavorite': isfavorite,
        'feedId': feedId,
        'files': files.map((f) => f.toJson()).toList(),
        'title': title,
        'content': content,
        'placeAround': placeAround,
        'placePrice': placePrice,
        'campKind': campKind,
        'hashTags': hashTags,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'bookmarkCount': bookmarkCount,
      };
}
