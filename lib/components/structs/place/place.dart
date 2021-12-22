import 'package:campy/models/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlaceInfo extends StatelessWidget {
  const PlaceInfo({
    Key? key,
    required this.mq,
    required this.iconImgH,
    required this.feed,
  }) : super(key: key);

  final MediaQueryData mq;
  final double iconImgH;
  final FeedInfo feed;
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
                  Text(" ${feed.campKind}")
                ]),
                SizedBox(height: 10),
                if (feed.addr != null)
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
                      child: TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: feed.addr));
                        },
                        child: Text(
                          "${feed.addr}",
                          overflow: TextOverflow.ellipsis,
                        ),
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
                  Text("  ${feed.placePrice} 만원")
                ]),
                SizedBox(height: 10),
                Row(children: [
                  Image.asset(
                    "assets/images/caution.png",
                    height: iconImgH - 7,
                  ),
                  Text(
                    "  ${feed.placeAround}",
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
