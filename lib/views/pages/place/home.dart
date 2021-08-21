import 'package:campy/models/place.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campy/providers/place.dart';

class PlaceHomeScreen extends StatelessWidget {
  const PlaceHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    // not subscribe CampPlaceProvider, Only Rebuild Child Of Consumer
    var _placeProvider = Provider.of<CampPlaceProvider>(ctx, listen: false);
    _placeProvider.getPlaces();
    var mq = MediaQuery.of(ctx);

    return Consumer<CampPlaceProvider>(builder: (ctx, placeProvider, child) {
      if (placeProvider.places.length > 20) {
        var ps = placeProvider.places[0];
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  child: Column(
                    children: [
                      Image.network(
                        "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947_960_720.jpg",
                        fit: BoxFit.fill,
                        height: mq.size.height / 3,
                        width: mq.size.width,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(ps.name!),
                          Text(ps.ctgr!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(ps.campPhone!),
                          Text(ps.areaSize!),
                          Text(ps.capacity!),
                          Text(ps.price!)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: mq.size.height / 3,
                  child: Text("$mq"),
                ),
                Container(
                  height: mq.size.height / 3,
                  child: Card(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/mocks/images/feed_2000x2000.jpg',
                          height: mq.size.height / 5,
                        ),
                        Row(children: [
                          Icon(Icons.ac_unit),
                          Icon(Icons.ac_unit),
                          Icon(Icons.ac_unit),
                          Icon(Icons.ac_unit)
                        ]),
                        Row(children: [
                          Icon(Icons.ac_unit),
                          const Text('Revolution is coming...'),
                          Icon(Icons.ac_unit),
                          const Text('Revolution is coming...'),
                        ])
                      ],
                    ),
                  ),
                ),
                Container(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 6,
                      itemBuilder: (ctx, idx) {
                        return Image.asset(
                            'assets/mocks/images/feed_2000x2000.jpg');
                      }),
                )
              ],
            ),
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
