import 'package:campy/models/user.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:image_picker/image_picker.dart';

class FeedInfo {
  FeedInfo(
      {required this.writer,
      required this.isfavorite,
      required this.feedId,
      required this.files,
      required this.fileTypes,
      required this.title,
      required this.content,
      hashTags})
      : hashTags = hashTags;
  final PyUser writer;
  final bool isfavorite;
  final String? feedId;
  final List<XFile> files;
  final List<XFileType> fileTypes;
  final String title;
  final String content;
  String hashTags;
  int likeCount = 0;
  int commentCount = 0;
  int shareCount = 0;
  int bookmarkCount = 0;

  @override
  String toString() {
    return "\n >>>>> User: $writer 's Feed: $title \n $hashTags \n $files \n <<<<<";
  }

  FeedInfo.fromJson(Map<String, dynamic> j)
      : writer = PyUser.fromJson(j),
        isfavorite = j['isfavorite'],
        feedId = j['id'],
        files = j['files'],
        fileTypes = j['fileTypes'],
        title = j['title'],
        content = j['content'],
        hashTags = j['hashTags'],
        likeCount = j['likeCount'] ?? 0,
        commentCount = j['commentCount'] ?? 0,
        shareCount = j['shareCount'] ?? 0,
        bookmarkCount = j['bookmarkCount'] ?? 0;

  Map<String, dynamic> toJson() => {
        'writer': writer.toJson(),
        'isfavorite': isfavorite,
        'feedId': feedId,
        'files': files,
        'fileTypes': fileTypes,
        'title': title,
        'content': content,
        'hashTags': hashTags,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'bookmarkCount': bookmarkCount,
      };
}
