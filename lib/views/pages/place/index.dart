import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campy/providers/place.dart';
import 'home.dart';

class PlaceCategoryView extends StatelessWidget {
  PlaceCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: ChangeNotifierProvider(
          create: (ctx) => CampPlaceProvider(), child: PlaceHomeScreen()),
    );
  }
}
