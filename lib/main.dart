import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigateus/mapFunctions/all.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


void main() => runApp(const NavigateUS());

class NavigateUS extends StatelessWidget {
  const NavigateUS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'NavigateUS',
      home: Map(),
    );
  }
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => MapSampleState();
}

class MapSampleState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();

  static const Marker nusMarker = Marker(
    markerId: MarkerId('nus'),
    infoWindow: InfoWindow(title: 'NUS'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(1.2966, 103.7764),
  );

  static const CameraPosition nus = CameraPosition(
    target: LatLng(1.2966, 103.7764),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildMap(),
          buildFloatingSearchBar(context),
        ],
      ),
      drawer: buildDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: () {
          // ToDo: Go to current location
        },
      ),
    );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: nus,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      zoomControlsEnabled: false,
    );
  }

}


