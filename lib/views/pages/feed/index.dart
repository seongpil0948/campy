import 'package:flutter/material.dart';
import 'package:campy/views/router/state.dart';

class FeedCategoryView extends StatelessWidget {
  FeedCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('fuck Demo'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          shape: CircleBorder(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FeedWidget(),
              FeedWidget(),
              FeedWidget(),
            ],
          ),
        ));
  }
}

class FeedWidget extends StatelessWidget {
  const FeedWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    var mq = MediaQuery.of(ctx);
    final appState = PyState();
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
                        backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947_960_720.jpg"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "data",
                      ),
                    ],
                  ),
                  Text(
                    "data",
                  ),
                  Text(
                    "data",
                    // FIXME: Theme
                  ),
                  Text(
                    "data",
                    // FIXME: Theme
                  ),
                  Text(
                    "data",
                    // FIXME: Theme
                  ),
                ],
              ),
            )
          ])),
    );
  }
}
