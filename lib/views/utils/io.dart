import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum PyFileType { Video, Image }

extension ParseToString on PyFileType {
  String toCustomString() {
    return this.toString().split('.').last;
  }
}

class PyFile {
  File? file;
  String? url;
  PyFileType ftype;

  PyFile.fromXfile({required XFile f, required this.ftype})
      : this.file = File(f.path);

  PyFile.fromCdn({required String this.url, required this.ftype});

  Map<String, dynamic> toJson() => {
        'url': url,
        'file': file?.path,
        'ftype': ftype,
      };

  PyFile.fromJson(j)
      : url = j['url'],
        ftype = j['ftype'];
}
