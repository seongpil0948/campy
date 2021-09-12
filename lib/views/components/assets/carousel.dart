import 'dart:io';

import 'package:campy/views/components/assets/upload.dart';
import 'package:campy/views/components/assets/video.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class PyAssetCarousel extends StatefulWidget {
  const PyAssetCarousel({Key? key}) : super(key: key);

  @override
  _PyAssetCarouselState createState() => _PyAssetCarouselState();
}

enum XFileType { Video, Image }

class _PyAssetCarouselState extends State<PyAssetCarousel> {
  CarouselController buttonCarouselController = CarouselController();
  List<XFile> _uploadFiles = [];
  List<XFileType> fileTypes = [];

  final ImagePicker _picker = ImagePicker();
  Widget carouselLayout(BuildContext ctx, Widget child) {
    final mq = MediaQuery.of(ctx);
    return Container(
      height: mq.size.height / 4,
      child: child,
    );
  }

  @override
  Widget build(BuildContext ctx) => Column(children: <Widget>[
        CarouselSlider.builder(
            itemCount: _uploadFiles.length + 1,
            itemBuilder: (BuildContext ctx, int idx, int pageViewIndex) {
              print(
                  "_uploadFileslength: ${_uploadFiles.length} \n pageViewIndex:$idx");
              if (idx == _uploadFiles.length) {
                return carouselLayout(
                    ctx,
                    AssetUploadCard(
                        photoPressed: () => pressAssetButton(false),
                        videoPressed: () => pressAssetButton(true)));
              }
              final file = File(_uploadFiles[idx].path);
              switch (fileTypes[idx]) {
                case XFileType.Image:
                  return carouselLayout(ctx, Image.file(file));
                case XFileType.Video:
                  return VideoW(file: file);
              }
            },
            options: CarouselOptions(
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 2.0,
              enableInfiniteScroll: false,
            )),
      ]);
  pressAssetButton(bool isVideo) async {
    if (isVideo) {
      final asset = await _picker.pickVideo(source: ImageSource.gallery);
      setState(() {
        if (asset != null) {
          _uploadFiles.add(asset);
          fileTypes.add(XFileType.Video);
        }
      });
      return null;
    }
    final imgs = await _picker.pickMultiImage();
    setState(() {
      if (imgs != null) {
        for (var i in imgs) {
          _uploadFiles.add(i);
          fileTypes.add(XFileType.Image);
        }
      }
    });
  }
}
