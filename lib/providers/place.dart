import 'package:campy/models/place.dart';
import 'package:flutter/material.dart';

class CampPlaceProvider extends ChangeNotifier {
  List<CampPlace> _places = [];
  List<CampPlace> get places => _places;

  getPlaces() async {
    Map rawPlaces = await loadPlaces();
    _places = (rawPlaces['records'] as List)
        .map((j) => CampPlace.fromJson(j))
        .toList();
    notifyListeners();
  }
}
