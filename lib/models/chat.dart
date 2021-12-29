import 'package:campy/models/user.dart';
import 'package:uuid/uuid.dart';

import 'common.dart';

class Msg extends Time {
  String id;
  PyUser writer;
  String content;
  Msg({
    required this.id,
    required this.writer,
    required this.content,
  });

  Msg.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        writer = PyUser.fromJson(j['writer']),
        content = j['content'],
        super.fromJson(j);

  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j['id'] = id;
    j['writer'] = writer.toJson();
    j['content'] = content;
    return j;
  }

  static Iterable<Msg> mocks(int n) {
    final users = PyUser.mocks(n).toList();
    const uuid = Uuid();
    return Iterable.generate(
        n,
        (i) => Msg.fromJson({
              "id": uuid.v4(),
              "writer": users[i].toJson(),
              "content": "asdasdl;vlx;cvldksfoakfoqkf;lkasdfl;kqo",
              "createdAt": DateTime.now().add(const Duration(days: -1)),
              "updatedAt": DateTime.now()
            }));
  }
}
