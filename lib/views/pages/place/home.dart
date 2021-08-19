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
