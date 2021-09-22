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
  late PyFileType ftype;

  PyFile.fromXfile({required XFile f, required this.ftype})
      : this.file = File(f.path);

  PyFile.fromCdn({required String this.url, required String fileType}) {
    switch (fileType) {
      case "Image":
        ftype = PyFileType.Image;
        break;
      case "Video":
        ftype = PyFileType.Video;
        break;
    }
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'file': file?.path,
        'ftype': ftype.toCustomString(),
      };

  PyFile.fromJson(j)
      : url = j['url'],
        ftype = j['ftype'];
}
