import 'dart:io';
import 'package:campy/components/assets/video.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum PyFileType { Video, Image }

extension ParseToString on PyFileType {
  String toCustomString() {
    return this.toString().split('.').last;
  }
}

PyFileType fileTypeFromString(String ftype) {
  switch (ftype) {
    case "Video":
      return PyFileType.Video;
    case "Image":
      return PyFileType.Image;
    default:
      return PyFileType.Image;
  }
}

class PyFile {
  File? file;
  String? url;
  late PyFileType ftype;

  PyFile.fromXfile({required XFile f, required this.ftype})
      : this.file = File(f.path);
  PyFile.fileName({required String fileName, required this.ftype})
      : this.file = File(fileName);

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
        ftype = fileTypeFromString(j['ftype']);
}

Widget loadFile({required PyFile f, required BuildContext ctx}) {
  final mq = MediaQuery.of(ctx);
  switch (f.ftype) {
    case PyFileType.Image:
      return f.file != null
          ? Image.file(
              f.file!,
              fit: BoxFit.cover,
              width: mq.size.width,
            )
          : CachedNetworkImage(
              imageUrl: f.url!,
              fit: BoxFit.cover,
              width: mq.size.width,
            );

    case PyFileType.Video:
      final c = f.file != null
          ? VideoPlayerController.file(f.file!)
          : VideoPlayerController.network(f.url!);
      return VideoW(controller: c);
  }
}
