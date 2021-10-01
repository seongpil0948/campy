import 'package:campy/views/components/assets/upload.dart';

import 'package:campy/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

final pyCarouselOption = CarouselOptions(
  enlargeCenterPage: true,
  viewportFraction: 1.0,
  aspectRatio: 1.6,
  enableInfiniteScroll: false,
);

class PyCarousel extends StatelessWidget {
  final List<PyFile> fs;
  PyCarousel({Key? key, required this.fs}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return CarouselSlider.builder(
        itemCount: fs.length,
        itemBuilder: (BuildContext ctx, int idx, int pageViewIndex) {
          var f = fs[idx];
          return loadFile(f: f, ctx: ctx);
        },
        options: pyCarouselOption);
  }
}

class PyAssetCarousel extends StatefulWidget {
  // For Feed Postring
  PyAssetCarousel({Key? key}) : super(key: key);

  @override
  _PyAssetCarouselState createState() => _PyAssetCarouselState();
}

class _PyAssetCarouselState extends State<PyAssetCarousel> {
  CarouselController buttonCarouselController = CarouselController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext ctx) {
    var fs = ctx.watch<List<PyFile>>();
    return Column(children: <Widget>[
      CarouselSlider.builder(
          itemCount: fs.length + 1,
          itemBuilder: (BuildContext ctx, int idx, int pageViewIndex) {
            if (idx == fs.length) {
              return AssetUploadCard(
                  photoPressed: () => pressAssetButton(false, ctx),
                  videoPressed: () => pressAssetButton(true, ctx));
            }
            var f = fs[idx];
            return loadFile(f: f, ctx: ctx);
          },
          options: pyCarouselOption),
    ]);
  }

  pressAssetButton(bool isVideo, BuildContext ctx) async {
    var fs = ctx.read<List<PyFile>>();
    if (isVideo) {
      final asset = await _picker.pickVideo(source: ImageSource.gallery);
      if (asset != null) {
        fs.add(PyFile.fromXfile(f: asset, ftype: PyFileType.Video));
      }
      return null;
    }
    final imgs = await _picker.pickMultiImage();
    if (imgs != null) {
      for (var i in imgs) {
        fs.add(PyFile.fromXfile(f: i, ftype: PyFileType.Image));
      }
    }
  }
}
