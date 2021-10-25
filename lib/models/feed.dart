import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedInfo {
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
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  @override
  String toString() {
    return "\n >>>>> User: $writer 's FeedInfo: \n Title$title \n tags: $hashTags \n Files: $files \n <<<<<";
  }

  Future<bool> update() {
    updatedAt = DateTime.now();
    final fc = getCollection(c: Collections.Feeds, userId: writer.userId);
    return fc
        .doc(feedId)
        .set(toJson(), SetOptions(merge: true))
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
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']);

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
        'updatedAt': updatedAt,
        'createdAt': createdAt
      };
}
