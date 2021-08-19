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
    return Consumer<CampPlaceProvider>(builder: (ctx, placeProvider, child) {
      if (placeProvider.places.length > 20) {
        return ListView.separated(
            itemCount: 20,
            itemBuilder: (BuildContext ctx, int idx) {
              var ps = placeProvider.places[idx];
              return ListTile(
                title: Text(ps.name ?? ""),
                subtitle: Text(ps.price ?? ""),
              );
            },
            separatorBuilder: (BuildContext ctx, int idx) {
              return Divider();
            });
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}
