import 'package:campy/views/components/assets/assetUpload.dart';
import 'package:campy/views/layouts/pyffold.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedPostView extends StatefulWidget {
  List<XFile>? _imageFileList;
  FeedPostView({Key? key})
      : _imageFileList = [],
        super(key: key);
  @override
  _FeedPostViewState createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    return Pyffold(
        fButton: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: mq.size.height / 3,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: AssetUpload(),
              ),
              Row(
                children: [],
              )
            ],
          ),
        ));
  }
}
