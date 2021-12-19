import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PyUserAvatar extends StatelessWidget {
  final String imgUrl;
  final double? radius;
  const PyUserAvatar({
    Key? key,
    this.radius,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius, backgroundImage: CachedNetworkImageProvider(imgUrl));
  }
}
