import 'package:campy/models/user.dart';
import 'package:flutter/material.dart';

class FeedWidget extends StatelessWidget {
  final PyUser user;
  FeedWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    var mq = MediaQuery.of(ctx);
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: mq.size.height / 40, horizontal: mq.size.width / 25),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(40.0),
          child: Stack(children: [
            Image.asset(
              "assets/images/mock.jpg",
              height: mq.size.height / 3,
              width: mq.size.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImage)),
                      SizedBox(width: 10),
                      Text("data"),
                    ],
                  ),
                  Text("data"),
                  Text("data"),
                  Text("data"),
                  Text("data"),
                ],
              ),
            )
          ])),
    );
  }
}
