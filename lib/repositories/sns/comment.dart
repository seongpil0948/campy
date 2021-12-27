import 'package:campy/models/comment.dart';
import 'package:campy/models/feed.dart';
import 'package:campy/models/reply.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:uuid/uuid.dart';

Future<List<Comment>> loadComment(String userId, String feedId) async {
  final comments = await getCollection(
          c: Collections.Comments, userId: userId, feedId: feedId)
      .orderBy('createdAt', descending: true)
      .get();
  return comments.docs
      .map((c) => Comment.fromJson(c.data() as Map<String, dynamic>))
      .toList();
}

void postComment(String txt, PyUser writer, FeedInfo feed) {
  final commentId = Uuid().v4();
  final comment = Comment(id: commentId, writer: writer, content: txt);
  final cj = comment.toJson();
  getCollection(
          c: Collections.Comments, userId: writer.userId, feedId: feed.feedId)
      .doc(commentId)
      .set(cj)
      .then((value) {
    print("Post Comment is Successed ");
  }).catchError((e) {
    print("Post Comment is Restricted: $e");
    FirebaseCrashlytics.instance
        .recordError(e, null, reason: 'Post Comment Error', fatal: true);
  });
}

void postReply(String txt, PyUser writer, String feedId, String commentId) {
  final replyId = Uuid().v4();
  final reply = Reply(
      id: commentId, writer: writer, content: txt, targetCmtId: commentId);
  final rj = reply.toJson();
  getCollection(c: Collections.Comments, userId: writer.userId, feedId: feedId)
      .doc(commentId)
      .collection(ReplyCollection)
      .doc(replyId)
      .set(rj)
      .then((value) {
    print("Post Reply is Successed ");
  }).catchError((e) {
    print("Post Reply is Restricted: $e");
    FirebaseCrashlytics.instance
        .recordError(e, null, reason: 'Post Reply Error', fatal: true);
  });
}
