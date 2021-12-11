import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:campy/config.dart';

const defaultZoom = 15.0;
const CameraPosition defaultPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: defaultZoom,
);

// ignore: must_be_immutable
class CampyMap extends StatefulWidget {
  final double? initLat;
  final double? initLng;
  CampyMap({Key? key, this.initLat, this.initLng}) : super(key: key);

  @override
  _CampyMapState createState() => _CampyMapState();
}

class _CampyMapState extends State<CampyMap> {
  Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  @override
  Widget build(BuildContext ctx) {
    var _markers = [
      Marker(
          markerId: MarkerId("1"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(widget.initLat!, widget.initLng!))
    ];
    return GoogleMap(
        mapType: MapType.hybrid,
        markers: Set.from(_markers),
        initialCameraPosition: widget.initLat != null && widget.initLng != null
            ? CameraPosition(
                target: LatLng(widget.initLat!, widget.initLng!),
                zoom: defaultZoom)
            : defaultPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true);
  }
}

// ignore: must_be_immutable
class SelectMapW extends StatefulWidget {
  void Function(PickResult) onPick;
  SelectMapW({Key? key, required this.onPick}) : super(key: key);

  @override
  _SelectMapWState createState() => _SelectMapWState();
}

class _SelectMapWState extends State<SelectMapW> {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  PickResult? selectedPlace;
  @override
  Widget build(BuildContext ctx) {
    final s = MediaQuery.of(ctx).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (selectedPlace != null && selectedPlace!.formattedAddress != null)
            Container(
              width: s.width / 2.5,
              padding: EdgeInsets.only(right: 5),
              child: Text(
                selectedPlace != null
                    ? "${selectedPlace?.formattedAddress}"
                    : '',
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ElevatedButton(
            child: Container(
              width: s.width / 4,
              child: Text(
                "캠핑장 위치 선택",
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () {
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (ctx) {
                    return Theme(
                        data: Theme.of(ctx).copyWith(
                            inputDecorationTheme: InputDecorationTheme()),
                        child: PlacePicker(
                          apiKey: GOOGLE_MAP_KEY,
                          initialPosition: kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          //usePlaceDetailSearch: true,
                          autocompleteLanguage: "ko",
                          region: 'KR',
                          selectedPlaceWidgetBuilder:
                              (_, place, state, isSearchBarFocused) {
                            return isSearchBarFocused
                                ? Container()
                                : FloatingCard(
                                    bottomPosition: 0.0,
                                    leftPosition: 0.0,
                                    rightPosition: 0.0,
                                    width: 500,
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: state == SearchingState.Searching
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : Column(
                                            children: [
                                              SizedBox(height: 20),
                                              Text(
                                                  "${place?.formattedAddress}"),
                                              ElevatedButton(
                                                child: Text(
                                                  "위치 선택 완료",
                                                  style: Theme.of(ctx)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                onPressed: () {
                                                  if (place != null) {
                                                    setState(() {
                                                      selectedPlace = place;
                                                      widget.onPick(place);
                                                    });
                                                    Navigator.of(ctx).pop();
                                                  }
                                                },
                                              ),
                                              SizedBox(height: 20)
                                            ],
                                          ),
                                  );
                          },
                          pinBuilder: (ctx, state) {
                            if (state == PinState.Idle) {
                              return Icon(Icons.favorite_border);
                            } else {
                              return Icon(Icons.favorite);
                            }
                          },
                        ));
                  },
                ),
              );
              selectedPlace == null
                  ? Container()
                  : Text(selectedPlace!.formattedAddress ?? "");
            },
          ),
        ],
      ),
    );
  }
}
