import 'package:campy/models/user.dart';
import 'package:campy/repositories/store/init.dart';

Future<Iterable<PyUser>> getAllUsers() async {
  // todo: Filtering Friends
  final collection = await getCollection(c: Collections.Users).get();
  return collection.docs.map(
      (userDoc) => PyUser.fromJson(userDoc.data()! as Map<String, dynamic>));
}
