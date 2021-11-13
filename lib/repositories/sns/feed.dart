import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/views/router/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

import '../upload_file.dart';

Future postFeed(
    {required BuildContext ctx,
    required PyUser writer,
    required List<PyFile> files,
    String? title,
    String? content,
    String? around,
    int? price,
    String? kind,
    required List<String> hashTags}) async {
  const uuid = Uuid();
  final newFeedId = uuid.v4();
  List<PyFile> paths = [];
  for (var f in files) {
    var info = await uploadFilePathsToFirebase(f, writer.userId);
    if (info != null && info.containsKey('url') && info.containsKey('pymime')) {
      var file = PyFile.fromCdn(url: info['url'], fileType: info['pymime']);
      paths.add(file);
    }
  }

  final doc = getCollection(c: Collections.Users).doc(writer.userId);
  var finfo = FeedInfo(
    writer: writer,
    feedId: newFeedId,
    files: paths,
    title: title ?? "",
    content: content ?? "",
    placeAround: around ?? '',
    placePrice: price ?? -1,
    campKind: kind ?? '',
    hashTags: hashTags,
  );
  // If you don't add a field to the document it will be orphaned.
  doc.set(writer.toJson(), SetOptions(merge: true));
  doc
      .collection(FeedCollection)
      .doc(newFeedId)
      .set(finfo.toJson())
      .then((value) {
    print(">>> Feed Added <<<");
    ctx.read<PyState>().currPageAction = PageAction.feed();
  }).catchError((error) {
    print("!!!Failed to add Feed!!!: ${error.toString()}");
  });
}
