import 'package:campy/views/components/assets/upload.dart';
import 'package:campy/views/components/assets/video.dart';
import 'package:campy/views/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:video_player/video_player.dart';

class PyAssetCarousel extends StatefulWidget {
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
            switch (f.ftype) {
              case PyFileType.Image:
                return f.file != null
                    ? Image.file(f.file!)
                    : Image.network(f.url!);

              case PyFileType.Video:
                final c = f.file != null
                    ? VideoPlayerController.file(f.file!)
                    : VideoPlayerController.network(f.url!);
                return VideoW(controller: c);
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
