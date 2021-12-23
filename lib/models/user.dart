import 'package:campy/repositories/init.dart';
import 'package:campy/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PyUser {
  String userId;
  String? displayName;
  String? email;
  bool emailVerified;
  String? phoneNumber;
  UserMetadata? metadata;
  String photoURL;
  List<UserInfo>? providerData;
  String? refreshToken;
  String? messageToken;
  String? tenantId;
  int hash;
  String get profileImage => photoURL;
  List<String> favoriteFeeds = [];
  List<PyUser> followers = [];
  List<PyUser> follows = [];
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  PyUser({required User user, required this.userId, this.messageToken})
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
    followers: $followers \n 
    follows: $follows \n
    createdAt: $createdAt 
    updatedAt: $updatedAt 
    """;
  }

  bool valid() {
    return userId.length > 3 && displayName != null && email != null;
  }

  Future<bool> update() async {
    updatedAt = DateTime.now();
    final doc = getCollection(c: Collections.Users).doc(userId);
    await doc.set(toJson(), SetOptions(merge: true));
    return true;
  }

  PyUser.fromJson(Map<String, dynamic> j)
      : userId = j['userId'],
        displayName = j['displayName'],
        email = j['email'],
        emailVerified = j['emailVerified'],
        phoneNumber = j['phoneNumber'],
        photoURL = j['photoURL'],
        refreshToken = j['refreshToken'],
        messageToken = j['messageToken'],
        tenantId = j['tenantId'],
        hash = j['hash'],
        favoriteFeeds = List<String>.from(j['favoriteFeeds']),
        followers =
            j['followers'].map<PyUser>((f) => PyUser.fromJson(f)).toList(),
        follows = j['follows'].map<PyUser>((f) => PyUser.fromJson(f)).toList(),
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']);

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'email': email,
        'emailVerified': emailVerified,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        'refreshToken': refreshToken,
        'messageToken': messageToken,
        'tenantId': tenantId,
        'hash': hash,
        'favoriteFeeds': favoriteFeeds,
        'followers': followers.map((f) => f.toJson()).toList(),
        'follows': follows.map((f) => f.toJson()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
