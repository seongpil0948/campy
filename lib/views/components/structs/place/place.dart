import 'package:flutter/material.dart';

class PlaceInfo extends StatelessWidget {
  const PlaceInfo({
    Key? key,
    required this.mq,
    required this.iconImgH,
  }) : super(key: key);

  final MediaQueryData mq;
  final double iconImgH;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: mq.size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Image.asset(
                    "assets/images/feed_icon_filled.png",
                    height: iconImgH,
                  ),
                  Text(" 글램핑")
                ]),
                SizedBox(height: 10),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    width: 1,
                  ),
                  Image.asset(
                    "assets/images/map_marker.png",
                    height: iconImgH - 3,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 180),
                    margin: EdgeInsets.only(left: mq.size.width / 80),
                    child: Text(
                      "경기도 광명시 가림일로",
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ]),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Image.asset(
                    "assets/images/won.png",
                    height: iconImgH - 7,
                  ),
                  Text("  유료 : 1일 10만원")
                ]),
                SizedBox(height: 10),
                Row(children: [
                  Image.asset(
                    "assets/images/caution.png",
                    height: iconImgH - 7,
                  ),
                  Text(
                    "  주변 마켓 없음",
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
