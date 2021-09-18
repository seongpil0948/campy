import 'package:cloud_firestore/cloud_firestore.dart';

enum Collections {
  Feeds,
  Users,
}

CollectionReference getCollection(Collections c) {
  FirebaseFirestore store = FirebaseFirestore.instance;
  switch (c) {
    case Collections.Feeds:
      return store.collection('feeds');
    case Collections.Users:
      return store.collection('users');
  }
}
