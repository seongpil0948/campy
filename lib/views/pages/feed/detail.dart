import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/state.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/layouts/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class FeedDetailView extends StatelessWidget {
  FeedDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final state = ctx.read<PyState>();
    final feed = state.selectedFeed!;
    return Scaffold(
        drawer: PyDrawer(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            PyCarousel(fs: feed.files),
            Text("Selected Feed: $feed", style: TextStyle(color: Colors.black))
          ],
        )));
  }
}
