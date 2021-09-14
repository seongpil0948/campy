import 'package:campy/config.dart';
import 'package:campy/models/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PyUser {
  String displayName;
  String email;
  bool emailVerified;
  String phoneNumber;
  UserMetadata metadata;
  String photoURL;
  List<UserInfo> providerData;
  String refreshToken;
  String tenantId;
  int hash;
  String get profileImage => photoURL;
  List<FeedInfo> feeds = [];
  List<PyUser> followers = [];
  List<PyUser> follows = [];
  PyUser({required User user})
      : displayName = user.displayName!,
        email = user.email!,
        emailVerified = user.emailVerified!,
        phoneNumber = user.phoneNumber!,
        metadata = user.metadata!,
        photoURL = user.photoURL!,
        providerData = user.providerData,
        refreshToken = user.refreshToken!,
        tenantId = user.tenantId!,
        hash = user.hashCode;

  // @override
  // String toString() {
  //   return "PyUser: Social: $ \n feeds: $feeds \n followers: $followers \n follows: $follows";
  // }

  PyUser.fromJson(Map<String, dynamic> j)
      : displayName = j['displayName'],
        email = j['email'],
        emailVerified = j['emailVerified'],
        phoneNumber = j['phoneNumber'],
        metadata = j['metadata'],
        photoURL = j['photoURL'],
        providerData = j['providerData'],
        refreshToken = j['refreshToken'],
        tenantId = j['tenantId'],
        hash = j['hashCode'],
        followers = j['followers'],
        follows = j['follows'];

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'email': email,
        'emailVerified': emailVerified,
        'phoneNumber': phoneNumber,
        'metadata': metadata,
        'photoURL': photoURL,
        'providerData': providerData,
        'refreshToken': refreshToken,
        'tenantId': tenantId,
        'hashCode': hashCode,
        'followers': followers,
        'follows': follows,
      };
}
