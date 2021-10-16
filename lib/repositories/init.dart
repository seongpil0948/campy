import 'package:cloud_firestore/cloud_firestore.dart';

enum Collections {
  Feeds,
  Users,
  Comments,
}

CollectionReference getCollection(
    {required Collections c, String? userId, String? feedId}) {
  FirebaseFirestore store = FirebaseFirestore.instance;
  switch (c) {
    case Collections.Feeds:
      if (userId == null)
        throw ArgumentError(
            "If you want a feed collection, please enter your user ID.");
      return store.collection('users').doc(userId).collection('feeds');
    case Collections.Comments:
      if (userId == null || feedId == null)
        throw ArgumentError(
            "If you want a Comment collection, please enter your user & feed ID.");
      return store
          .collection('users')
          .doc(userId)
          .collection('feeds')
          .doc(feedId)
          .collection('comments');
    case Collections.Users:
      return store.collection('users');
  }
}
