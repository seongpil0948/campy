import 'dart:io';

import 'package:campy/utils/io.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<PyFile?> uploadFilePathsToFirebase(
    {required PyFile f, required String path}) async {
  // /uploads/$p
  var storeRef = FirebaseStorage.instance.ref().child(path);
  SettableMetadata metadata = SettableMetadata(
    // cacheControl: 'max-age=60',
    customMetadata: <String, String>{
      'pymime': f.ftype.toCustomString(),
    },
  );
  var task = storeRef.putFile(File(f.file!.path), metadata);

  task.snapshotEvents.listen((TaskSnapshot snapshot) {
    print('Task state: ${snapshot.state}');
    print(
        'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  }, onError: (e) {
    // The final snapshot is also available on the task via `.snapshot`,
    // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
    print(task.snapshot);

    if (e.code == 'permission-denied') {
      print('User does not have permission to upload to this reference.');
    }
  });

  // We can still optionally use the Future alongside the stream.
  try {
    await task;
    var meta = await storeRef.getMetadata();
    final info = {
      "url": await storeRef.getDownloadURL(),
      "pymime": meta.customMetadata!['pymime']
    };
    if (info.containsKey('url') && info.containsKey('pymime')) {
      return PyFile.fromCdn(url: info['url']!, fileType: info['pymime']!);
    }
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      print('User does not have permission to upload to this reference.');
    }
    // ...
  }
}
