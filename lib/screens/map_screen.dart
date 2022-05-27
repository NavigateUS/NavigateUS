import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigateus/mapFunctions/bottom_sheet.dart';
import 'package:navigateus/mapFunctions/geolocator_service.dart';
import 'package:navigateus/screens/drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapState();
}

class MapState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final FloatingSearchBarController floatingSearchBarController =
      FloatingSearchBarController();
  GooglePlace googlePlace =
      GooglePlace('AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');
  List<AutocompletePrediction> predictions = [];

  // Page Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          buildMap(),
          buildSearchBar(context),
        ]),
        drawer: buildDrawer(context),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.location_searching),
            onPressed: () {
              locateUserPosition();
            }));
  }

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

  // Search Bar
  Widget buildSearchBar(BuildContext context) {
    // Search Bar Functions
    void autoCompleteSearch(String value) async {
      var result = await googlePlace.autocomplete
          .get(value, location: const LatLon(1.2966, 103.7764), radius: 1000);
      if (result != null && result.predictions != null && mounted) {
        setState(() {
          predictions = result.predictions!;
        });
      }
    }

    Future<LatLng> getPlacePosition(index) async {
      final placeID = predictions[index].placeId!;
      final details = await googlePlace.details.get(placeID);
      if (details != null && details.result != null) {
        double? lat = details.result!.geometry!.location!.lat;
        double? lng = details.result!.geometry!.location!.lng;
        LatLng latLngPos = LatLng(lat!, lng!);
        return latLngPos;
      } else {
        return Future.error("Cannot find");
      }
    }

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Where would you like to go?',
      controller: floatingSearchBarController,
      automaticallyImplyDrawerHamburger: true,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transition: SlideFadeFloatingSearchBarTransition(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.bounceInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (value) {
        if (value.isNotEmpty) {
          //places api
          autoCompleteSearch(value);
        } else {
          //clear predictions
          setState(() {
            predictions = [];
          });
        }
      },
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      onSubmitted: (value) async {
        LatLng position = await getPlacePosition(0);
        goToPlace(position);
        floatingSearchBarController.close();
        String name = predictions[0].description.toString();
        var id = predictions[0].placeId;
        bottomSheet(context, name, id);
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            elevation: 2.0,
            // Child: This is whatever shows up below the search bar
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.pin_drop_outlined),
                  ),
                  title: Text(predictions[index].description.toString()),
                  onTap: () async {
                    String name = predictions[index].description.toString();
                    var id = predictions[index].placeId;
                    LatLng position = await getPlacePosition(index);
                    goToPlace(position);
                    floatingSearchBarController.close();
                    bottomSheet(context, name, id);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
