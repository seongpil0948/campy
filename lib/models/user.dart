import 'package:campy/models/feed.dart';
import 'package:campy/repositories/store/init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'common.dart';

class PyUser with PyDateMixin {
  String userId;
  String? displayName;
  String? email;
  bool emailVerified;
  String? phoneNumber;
  UserMetadata? metadata;
  String photoURL;
  List<UserInfo>? providerData;
  String? refreshToken;
  String? tenantId;
  int hash;
  String get profileImage => photoURL;
  List<FeedInfo> feeds = [];
  List<String> favoriteFeeds = [];
  List<PyUser> followers = [];
  List<PyUser> follows = [];
  PyUser({required User user, required this.userId})
      : displayName = user.displayName,
        email = user.email,
        emailVerified = user.emailVerified,
        phoneNumber = user.phoneNumber,
        metadata = user.metadata,
        photoURL = user.photoURL!,
        providerData = user.providerData,
        refreshToken = user.refreshToken,
        tenantId = user.tenantId,
        hash = user.hashCode;

  @override
  String toString() {
    return """
    PyUser: name: $displayName \n 
    providerData: $providerData \n 
    tenantId: $tenantId \n
    feeds: $feeds \n 
    followers: $followers \n 
    follows: $follows \n
    createdAt: $createdAt 
    updatedAt: $updatedAt 
    """;
  }

  Future<bool> update() {
    updateTime();
    final doc = getCollection(c: Collections.Users).doc(userId);
    return doc
        .set(toJson(), SetOptions(merge: true))
        .then((value) => true)
        .catchError((e) => false);
  }

  PyUser.fromJson(Map<String, dynamic> j)
      : userId = j['userId'],
        displayName = j['displayName'],
        email = j['email'],
        emailVerified = j['emailVerified'],
        phoneNumber = j['phoneNumber'],
        photoURL = j['photoURL'],
        refreshToken = j['refreshToken'],
        tenantId = j['tenantId'],
        hash = j['hashCode'],
        followers =
            j['followers'].map<PyUser>((f) => PyUser.fromJson(j)).toList(),
        follows = j['follows'].map<PyUser>((f) => PyUser.fromJson(j)).toList();

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'email': email,
        'emailVerified': emailVerified,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        'refreshToken': refreshToken,
        'tenantId': tenantId,
        'hashCode': hashCode,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'followers': followers.map((f) => f.toJson()).toList(),
        'follows': follows.map((f) => f.toJson()).toList(),
      };
}
