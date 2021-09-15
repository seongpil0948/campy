import 'dart:io';

import 'package:campy/views/components/assets/upload.dart';
import 'package:campy/views/components/assets/video.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

class PyAssetCarousel extends StatefulWidget {
  List<XFile> uploadFiles;
  List<XFileType> fileTypes;
  PyAssetCarousel(
      {Key? key, required this.uploadFiles, required this.fileTypes})
      : super(key: key);

  @override
  _PyAssetCarouselState createState() => _PyAssetCarouselState();
}

enum XFileType { Video, Image }

class _PyAssetCarouselState extends State<PyAssetCarousel> {
  CarouselController buttonCarouselController = CarouselController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext ctx) {
    var uploadFiles = widget.uploadFiles;
    var fileTypes = widget.fileTypes;
    return Column(children: <Widget>[
      CarouselSlider.builder(
          itemCount: uploadFiles.length + 1,
          itemBuilder: (BuildContext ctx, int idx, int pageViewIndex) {
            if (idx == uploadFiles.length) {
              return AssetUploadCard(
                  photoPressed: () => pressAssetButton(false),
                  videoPressed: () => pressAssetButton(true));
            }
            final file = File(uploadFiles[idx].path);
            switch (fileTypes[idx]) {
              case XFileType.Image:
                return Image.file(file);
              case XFileType.Video:
                return VideoW(file: file);
            }
          },
          options: CarouselOptions(
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            aspectRatio: 1.6,
            enableInfiniteScroll: false,
          )),
    ]);
  }

  pressAssetButton(bool isVideo) async {
    if (isVideo) {
      final asset = await _picker.pickVideo(source: ImageSource.gallery);
      setState(() {
        if (asset != null) {
          widget.uploadFiles.add(asset);
          widget.fileTypes.add(XFileType.Video);
        }
      });
      return null;
    }
    final imgs = await _picker.pickMultiImage();
    setState(() {
      if (imgs != null) {
        for (var i in imgs) {
          widget.uploadFiles.add(i);
          widget.fileTypes.add(XFileType.Image);
        }
      }
    });
  }
}
