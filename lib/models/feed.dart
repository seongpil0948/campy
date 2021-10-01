import 'package:campy/models/comment.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:campy/utils/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String feedId;
  final List<PyFile> files;
  final String title;
  final String content;
  final String placeAround;
  final int placePrice;
  final String campKind;
  String hashTags;
  List<String> likeUserIds = [];
  List<String> sharedUserIds = [];
  List<String> bookmarkedUserIds = [];
  List<Comment> comments = [];

  @override
  String toString() {
    return "\n >>>>> User: $writer 's FeedInfo: \n Title$title \n tags: $hashTags \n Files: $files \n <<<<<";
  }

  Future<bool> update(FeedInfo f) {
    updateTime();
    final doc = getCollection(Collections.Users).doc(writer.userId);
    return doc
        .collection("feeds")
        .doc(feedId)
        .set(f.toJson(), SetOptions(merge: true))
        .then((value) => true)
        .catchError((e) => false);
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
        likeUserIds = j['likeUserIds'].cast<String>(),
        sharedUserIds = j['sharedUserIds'].cast<String>(),
        bookmarkedUserIds = j['bookmarkedUserIds'].cast<String>(),
        // FIXME: 현재 받아올때마다 DocumentID를 함께 가져오긴 하지만 이건 문제가 있다.
        comments = j['comments']
            .map<Comment>((c) => Comment.fromJson(c, c['commentId']))
            .toList();

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
        'likeUserIds': likeUserIds,
        'sharedUserIds': sharedUserIds,
        'bookmarkedUserIds': bookmarkedUserIds,
        'comments': comments.map((c) => c.toJson()).toList(),
      };
}
