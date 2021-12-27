import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';

Future<Iterable<PyUser>> getAllUsers() async {
  // todo: Filtering Friends
  final collection = await getCollection(c: Collections.Users)
      .orderBy('updatedAt', descending: true)
      .get();
  return collection.docs.map(
      (userDoc) => PyUser.fromJson(userDoc.data()! as Map<String, dynamic>));
}
