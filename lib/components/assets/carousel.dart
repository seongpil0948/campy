import 'package:campy/components/assets/upload.dart';
import 'package:campy/components/structs/dot.dart';
import 'package:campy/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

// https://github.com/serenader2014/flutter_carousel_slider/blob/master/lib/carousel_options.dart
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
                  photoPressed: () => _pressAssetButton(false, ctx),
                  videoPressed: () => _pressAssetButton(true, ctx));
            }
            var f = fs[idx];
            return loadFile(f: f, ctx: ctx);
          },
          options: pyCarouselOption),
    ]);
  }

  _pressAssetButton(bool isVideo, BuildContext ctx) async {
    var fs = ctx.read<List<PyFile>>();
    if (isVideo) {
      final asset = await _picker.pickVideo(source: ImageSource.gallery);
      if (asset != null) {
        setState(() {
          fs.add(PyFile.fromXfile(f: asset, ftype: PyFileType.Video));
        });
      }
      return null;
    }
    final imgs = await _picker.pickMultiImage();
    if (imgs != null) {
      setState(() {
        for (var i in imgs) {
          fs.add(PyFile.fromXfile(f: i, ftype: PyFileType.Image));
        }
      });
    }
  }
}

class PyDotCorousel extends StatefulWidget {
  final List<Image> imgs;
  const PyDotCorousel({Key? key, required this.imgs}) : super(key: key);

  @override
  _PyDotCorouselState createState() => _PyDotCorouselState();
}

class _PyDotCorouselState extends State<PyDotCorousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider.builder(
        itemCount: widget.imgs.length,
        carouselController: _controller,
        itemBuilder: (BuildContext ctx, int idx, int pageViewIndex) =>
            widget.imgs[idx],
        options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            aspectRatio: 1.3,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Positioned(
        bottom: 10,
        right: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgs.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: DotCircle(
                  width: 12.0,
                  height: 12.0,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
