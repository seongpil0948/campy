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
  List<String> followers = [];
  List<String> follows = [];
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  PyUser({required User user, this.messageToken})
      : displayName = user.displayName,
        email = user.email,
        userId = user.uid,
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

  // ignore: hash_and_equals, test_types_in_equals
  bool operator ==(other) => this.userId == (other as PyUser).userId;

  Future<bool> update() async {
    updatedAt = DateTime.now();
    final doc = getCollection(c: Collections.Users).doc(userId);
    await doc.set(toJson(), SetOptions(merge: true));
    return true;
  }

  Future<List<PyUser>> usersByIds(List<String> userIds) async {
    final uCol = getCollection(c: Collections.Users);
    const chunkSize = 9;
    List<Future<QuerySnapshot<Object?>>> futures = [];
    for (var i = 0; i < userIds.length; i += chunkSize) {
      final chunkIds = userIds.sublist(
          i, i + chunkSize > userIds.length ? userIds.length : i + chunkSize);
      futures.add(uCol.where('userId', whereIn: chunkIds).get());
    }
    final queryResults = await Future.wait(futures);
    List<PyUser> users = [];
    for (var j in queryResults) {
      users.addAll(
          j.docs.map((e) => PyUser.fromJson(e.data() as Map<String, dynamic>)));
    }
    return users;
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
        followers = List<String>.from(j['followers']),
        follows = List<String>.from(j['follows']),
        createdAt = j['createdAt'] is DateTime
            ? j['createdAt']
            : timeStamp2DateTime(j['createdAt']),
        updatedAt = j['updatedAt'] is DateTime
            ? j['updatedAt']
            : timeStamp2DateTime(j['updatedAt']);

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
        'followers': followers,
        'follows': follows,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static Iterable<PyUser> mocks(int n) {
    return Iterable.generate(
        n,
        (i) => PyUser.fromJson({
              'userId': "spsp$i",
              'displayName': "spspspsp",
              'email': "seongpil0948@gmail.com",
              'emailVerified': i % 2 == 0 ? true : false,
              'phoneNumber': i % 2 == 0 ? "010-7184-0948" : null,
              'photoURL': "https://picsum.photos/250?image=$i",
              'refreshToken': "asdasfasfasfasfgadg",
              'messageToken': "asdasfasfasfasfgadg",
              'tenantId': "asdasfasfasfasfgadg",
              'hash': 1010012312412,
              'favoriteFeeds': [],
              'followers': [],
              'follows': [],
              'createdAt': Timestamp.now(),
              'updatedAt': Timestamp.now(),
            }));
  }
}
