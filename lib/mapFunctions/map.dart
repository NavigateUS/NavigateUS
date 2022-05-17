import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navigateus/mapFunctions/all.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);


  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapController;

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
          locatePosition();
        },
      ),
    );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: nus,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        googleMapController = controller;
      },
    );
  }

  void locatePosition() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng latLngPos = LatLng(
          currentPosition.latitude, currentPosition.longitude);

      CameraPosition pos = CameraPosition(target: latLngPos, zoom: 17.5);
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(pos));
    }
    catch (e) {
      print('Could not get location');
      // ToDo: Request for location permission
    }
  }

}