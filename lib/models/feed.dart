import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FeedInfo {
  late PyUser writer;
  final String feedId;
  final List<PyFile> files;
  String title;
  String content;
  String placeAround;
  int placePrice;
  String campKind;
  String? addr;
  double? lat;
  double? lng; // lat lng
  List<String> hashTags = [];
  List<String> likeUserIds = [];
  List<String> sharedUserIds = [];
  List<String> bookmarkedUserIds = [];
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  FeedInfo(
      {required this.writer,
      required this.feedId,
      required this.files,
      required this.title,
      required this.content,
      required this.placeAround,
      required this.placePrice,
      required this.campKind,
      required this.hashTags,
      required this.addr,
      required this.lat,
      required this.lng});

  FeedInfo.init()
      : files = [],
        feedId = const Uuid().v4(),
        title = '',
        content = '',
        placePrice = 0,
        campKind = '',
        placeAround = '',
        hashTags = [];

  @override
  String toString() {
    var str =
        "\n >>>>> User: $writer 's FeedInfo: \n Title$title \n tags: $hashTags \n Files: $files \n <<<<<";
    if (addr != null) str += "Address: $addr";
    return str;
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

  FeedInfo.fromJson(Map<String, dynamic> j)
      : writer = PyUser.fromJson(j['writer']),
        feedId = j['feedId'],
        files = j['files'].map<PyFile>((f) => PyFile.fromJson(f)).toList(),
        title = j['title'],
        content = j['content'],
        placeAround = j['placeAround'],
        placePrice = j['placePrice'],
        campKind = j['campKind'],
        hashTags = j['hashTags'].cast<String>(),
        likeUserIds = j['likeUserIds'].cast<String>(),
        sharedUserIds = j['sharedUserIds'].cast<String>(),
        bookmarkedUserIds = j['bookmarkedUserIds'].cast<String>(),
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']),
        addr = j['addr'] ?? null,
        lat = j['lat'] ?? null,
        lng = j['lng'] ?? null;

  Map<String, dynamic> toJson() => {
        'writer': writer.toJson(),
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
        'createdAt': createdAt,
        'addr': addr,
        'lat': lat,
        'lng': lng,
      };
}
