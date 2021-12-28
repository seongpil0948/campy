import 'package:cloud_firestore/cloud_firestore.dart';

enum Collections {
  Feeds,
  Users,
  Comments,
  Messages,
}

CollectionReference getCollection(
    {required Collections c, String? userId, String? feedId}) {
  FirebaseFirestore store = FirebaseFirestore.instance;
  switch (c) {
    case Collections.Feeds:
      if (userId == null)
        throw ArgumentError(
            "If you want a feed collection, please enter your user ID.");
      return store
          .collection(UserCollection)
          .doc(userId)
          .collection(FeedCollection);
    case Collections.Comments:
      if (userId == null || feedId == null)
        throw ArgumentError(
            "If you want a Comment collection, please enter your user & feed ID.");
      return store
          .collection(UserCollection)
          .doc(userId)
          .collection(FeedCollection)
          .doc(feedId)
          .collection(CommentCollection);
    case Collections.Users:
      return store.collection(UserCollection);
    case Collections.Messages:
      return store.collection(MessagesCollection);
  }
}

const UserCollection = 'users';
const FeedCollection = 'feeds';
const CommentCollection = 'comments';
const ReplyCollection = 'replies';
const MessagesCollection = 'messages';
