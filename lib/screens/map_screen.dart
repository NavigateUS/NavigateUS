import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigateus/mapFunctions/geolocator_service.dart';
import 'package:navigateus/screens/drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapState();
}

class MapState extends State<MapScreen> {
  String key = 'AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM';
  final Completer<GoogleMapController> _controller = Completer();
  final FloatingSearchBarController floatingSearchBarController =
      FloatingSearchBarController();
  late GooglePlace googlePlace =
      GooglePlace(key);
  List<AutocompletePrediction> predictions = [];
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  bool visibility = false;
  String totalDistance = '';
  String totalDuration = '';
  String destination = '';
  String modeOfTransit = '';

  // Page Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          buildMap(),
          buildSearchBar(context),
          buildDirections(),
        ]),
        drawer: buildDrawer(context),
        floatingActionButton: Padding(
          padding: visibility ? const EdgeInsets.only(bottom: 100) : const EdgeInsets.only(bottom: 0),
            child: FloatingActionButton(
                child: const Icon(Icons.location_searching),
                onPressed: () {
                  locateUserPosition();
                }
            ),
        )
    );
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
      markers: Set.from(markers),
      polylines: Set<Polyline>.of(polylines.values),
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

  void bottomSheet(BuildContext context, String name, var id) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        isScrollControlled: true,
        builder: (context) {
          return Wrap(
              children: [
                Center(
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(height: 10,),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //walk
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  getDirections(id, TravelMode.walking);
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(const StadiumBorder()),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.directions_walk),
                                    Text('Walk')
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10,),

                              //drive
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  getDirections(id, TravelMode.driving);
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(const StadiumBorder()),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.directions_car),
                                    Text('Drive')
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10,),

                              //transit
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  getDirections(id, TravelMode.transit);
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(const StadiumBorder()),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.directions_bus),
                                    Text('Transit')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3,),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            viewIndoorMap(id);
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(const StadiumBorder()),
                              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                              maximumSize: MaterialStateProperty.all(const Size.fromWidth(300))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.map_outlined),
                              Text('View Indoor Map')
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                      ],
                    )
                )
              ]
          );
        }
    );
  }


  Future<void> getDirections(var endID, TravelMode mode) async {
    Position userPosition = await GeolocatorService().getCurrentLocation();
    LatLng latLngPosStart = LatLng(
        userPosition.latitude, userPosition.longitude);
    Marker startMarker = Marker(
        markerId: const MarkerId('Start'),
        position: latLngPosStart);

    final details = await googlePlace.details.get(endID);
    LatLng latLngPosEnd = LatLng(details!.result!.geometry!.location!.lat!,
        details!.result!.geometry!.location!.lng!);

    Marker endMarker = Marker(
        markerId: const MarkerId('End'),
        position: latLngPosEnd);

    Dio dio = Dio();
    String endLat = latLngPosEnd.latitude.toString();
    String endLng = latLngPosEnd.longitude.toString();
    String stLat = latLngPosStart.latitude.toString();
    String stLng = latLngPosStart.longitude.toString();

    if (mode == TravelMode.driving) {
      setState(() => modeOfTransit = 'driving');
    }
    else if (mode == TravelMode.walking) {
      setState(() => modeOfTransit = 'walking');
    }
    else if (mode == TravelMode.transit) {
      setState(() => modeOfTransit = 'transit');
    }

    Response response = await dio.get(
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLat,$endLng&origins=$stLat,$stLng&mode=$modeOfTransit&key=AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');

    String distance = response.data['rows'][0]['elements'][0]['distance']['text'];
    String duration = response.data['rows'][0]['elements'][0]['duration']['text'];

    setState(() {
      totalDistance = distance;
      totalDuration = duration;
      markers = {startMarker, endMarker};
      destination = details!.result!.name!;
    });

    _getPolyline(latLngPosStart, latLngPosEnd, mode, );
    floatingSearchBarController.hide();
    visibility = true;
    locateUserPosition();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates, width: 7);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(LatLng start, LatLng end, TravelMode mode,) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        key,
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(end.latitude, end.longitude),
        travelMode: mode,);

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }


  void viewIndoorMap(id) {
    var available = [
      'ChIJW-fkx_ga2jERSjkkKeJjaUM', //com1
      'ChIJRafctPga2jER8aiJ3XzHihM' //com2
    ];

    //ToDo: navigate to indoor map
  }

  Widget buildDirections() {
    return Positioned(
      bottom: 0,
      child: Visibility(
        visible: visibility, // Set it to false
        child: Container(
          width: 400,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.grey[300],
          ),
          child: Column(
            children: [
              Text(destination, style: const TextStyle(fontSize: 20),),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[400],
                ),
                child: Wrap(
                  children: [
                    if (modeOfTransit == 'walking') ...[
                      const Icon(Icons.directions_walk, size: 20,)
                    ] else if(modeOfTransit == 'driving')...[
                      const Icon(Icons.directions_car)
                    ] else if(modeOfTransit == 'transit')...[
                      const Icon(Icons.directions_bus)
                    ],
                    Text(totalDuration, style: const TextStyle(fontSize: 18),),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  closeDirections();
                },
                icon: const Icon(Icons.close)
              ),
            ],
          )
        ),
      ),
    );
  }

  void closeDirections() {
    floatingSearchBarController.show();
    setState(() {
      visibility = false;
      polylines = {};
      markers = {};
      polylineCoordinates = [];
    });

  }

}
