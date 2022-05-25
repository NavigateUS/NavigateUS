import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigateus/mapFunctions/geolocator_service.dart';
import 'package:navigateus/mapFunctions/search_bar.dart';
import 'package:navigateus/screens/drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapState();
}

class MapState extends State<MapScreen> {
  late final Completer<GoogleMapController> _controller = Completer();

  // Initial camera position NUS
  static const CameraPosition nusPosition = CameraPosition(
    target: LatLng(1.2966, 103.7764),
    zoom: 14.4746,
  );

  //Map
  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: nusPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  // Page Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [buildMap(), const FloatingSearchBarWidget()]),
        drawer: buildDrawer(context),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.location_searching),
            onPressed: () {
              locateUserPosition();
    }));
  }


  // Map Functions
  void locateUserPosition() async {
    try {
      Position userPosition = await GeolocatorService().getCurrentLocation();
      LatLng latLngPos = LatLng(userPosition.latitude, userPosition.longitude);
      goToPlace(latLngPos);
    } catch (error) {
      print(error);
    }
  }

  void goToPlace(LatLng latLngPos) async {
    try {
      GoogleMapController controller = await _controller.future;
      CameraPosition pos = CameraPosition(target: latLngPos, zoom: 17);
      controller.animateCamera(CameraUpdate.newCameraPosition(pos));
    } catch (error) {
      print(error);
    }
  }
}
