import 'package:campy/models/feed.dart';
import 'package:campy/models/state.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/views/router/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import '../upload_file.dart';

Future postFeed({required BuildContext ctx}) async {
  var state = ctx.read<PyState>();
  state.isLoading = true;
  List<PyFile> paths = [];
  try {
    final feed = ctx.read<FeedInfo>();
    feed.writer = await ctx.read<PyAuth>().currUser;

    for (var f in feed.files) {
      var info = await uploadFilePathsToFirebase(f, feed.writer.userId);
      if (info != null &&
          info.containsKey('url') &&
          info.containsKey('pymime')) {
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
      addr: feed.addr,
      lat: feed.lat,
      lng: feed.lng,
    );
    // If you don't add a field to the document it will be orphaned.
    doc.set(feed.writer.toJson(), SetOptions(merge: true));
    doc
        .collection(FeedCollection)
        .doc(feed.feedId)
        .set(finfo.toJson())
        .then((value) {
      print(">>> Feed Added <<<");
      state.currPageAction = PageAction.feed();
    });
  } catch (e, s) {
    print(
        '!!!Failed to add Feed!!! Exception details:\n $e \n Stack trace:\n $s');
  } finally {
    state.isLoading = false;
  }
}
