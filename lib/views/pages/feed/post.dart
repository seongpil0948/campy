import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/layouts/pyffold.dart';
import 'package:flutter/material.dart';

class FeedPostView extends StatefulWidget {
  FeedPostView({Key? key}) : super(key: key);
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
                child: PyAssetCarousel(),
              ),
              Row(
                children: [],
              )
            ],
          ),
        ));
  }
}
