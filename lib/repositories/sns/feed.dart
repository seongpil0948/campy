import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/views/router/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import '../upload_file.dart';

Future postFeed({required BuildContext ctx, required FeedInfo feed}) async {
  List<PyFile> paths = [];
  for (var f in feed.files) {
    var info = await uploadFilePathsToFirebase(f, feed.writer.userId);
    if (info != null && info.containsKey('url') && info.containsKey('pymime')) {
      var file = PyFile.fromCdn(url: info['url'], fileType: info['pymime']);
      paths.add(file);
    }
  }

  final doc = getCollection(c: Collections.Users).doc(feed.writer.userId);
  var finfo = FeedInfo(
    writer: feed.writer,
    feedId: feed.feedId,
    files: paths,
    title: feed.title,
    content: feed.content,
    placeAround: feed.placeAround,
    placePrice: feed.placePrice,
    campKind: feed.campKind,
    hashTags: feed.hashTags,
  );
  // If you don't add a field to the document it will be orphaned.
  doc.set(feed.writer.toJson(), SetOptions(merge: true));
  doc
      .collection(FeedCollection)
      .doc(feed.feedId)
      .set(finfo.toJson())
      .then((value) {
    print(">>> Feed Added <<<");
    ctx.read<PyState>().currPageAction = PageAction.feed();
  }).catchError((error) {
    print("!!!Failed to add Feed!!!: ${error.toString()}");
  });
}
