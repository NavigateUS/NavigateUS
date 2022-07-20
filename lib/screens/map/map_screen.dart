import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigateus/bus_data/bus_stops.dart';
import 'package:navigateus/screens/map/functions/geolocator_service.dart';
import 'package:navigateus/screens/drawer.dart';
import 'package:navigateus/screens/map/functions/bus_directions_service.dart';
import 'package:navigateus/bus_data/bus_stop_latlng.dart';
import 'package:navigateus/screens/map/widgets/bus_directions.dart';
import 'package:navigateus/places.dart';
import 'package:geopointer/geopointer.dart';
import 'package:navigateus/screens/timetable/timetable_screen.dart';

import '../timetable/components/data_source.dart';

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
  late GooglePlace googlePlace = GooglePlace(key);
  bool hasData = false;
  List<Place> predictions = [];
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  bool visibility = false;
  Place destination = Place('NUS', const LatLng(1.2966, 103.7764));
  String totalDistance = '';
  String totalDuration = '';
  String modeOfTransit = '';
  String totalDuration2 = '';
  late List<DirectionInstructions> instructions = [];
  late StreamSubscription<Position> locationStream;
  // Page Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Listener(
            onPointerDown: (drag) {
              locationStream.cancel();
            },
            child: Stack(children: [
              buildMap(),
              buildSearchBar(context),
              buildDirections(),
            ])),
        drawer: buildDrawer(context),
        floatingActionButton: Padding(
          padding: visibility
              ? const EdgeInsets.only(bottom: 120)
              : const EdgeInsets.only(bottom: 0),
          child: FloatingActionButton(
              child: const Icon(Icons.location_searching),
              onPressed: () {
                locateUserPosition();
              }),
        ));
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
      await GeolocatorService().getCurrentLocation();
      locationStream =
          GeolocatorService().getLocationStream().listen((latLngPos) {
        goToPlace(LatLng(latLngPos.latitude, latLngPos.longitude));
      });
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
    void autoCompleteSearch(String query) {
      final suggestions = locations.where((place) {
        final name = place.name.toLowerCase();
        final input = query.toLowerCase();

        return name.contains(input);
      }).toList();

      setState(() => predictions = suggestions);
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
      onQueryChanged: (value) {
        if (value.isNotEmpty) {
          //places api
          autoCompleteSearch(value);
        } else {
          //clear predictions
          setState(() {
            predictions = moduleDataSource.getPlaces();
          });
        }
      },
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      onSubmitted: (value) async {
        Place place = predictions[0];
        goToPlace(place.latLng);
        floatingSearchBarController.close();
        String name = place.name;
        bottomSheet(context, place);
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
                  title: Text(predictions[index].name),
                  onTap: () async {
                    String name = predictions[index].name;
                    LatLng position = predictions[index].latLng;
                    goToPlace(position);
                    floatingSearchBarController.close();
                    bottomSheet(context, predictions[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Location Result Bottom Sheet
  void bottomSheet(BuildContext context, Place place) {
    Marker marker =
        Marker(markerId: const MarkerId('search'), position: place.latLng);
    setState(() {
      destination = place;
      markers.add(marker);
    });
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        isScrollControlled: true,
        builder: (context) {
          return Wrap(children: [
            Center(
                child: Column(
              children: [
                Text(
                  place.name,
                  style: const TextStyle(fontSize: 20.0),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //walk
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getDirections(place, TravelMode.walking);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.directions_walk),
                            Text('Walk')
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      //drive
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getDirections(place, TravelMode.driving);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.directions_car),
                            Text('Drive')
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      //transit
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getDirections(place, TravelMode.transit);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange),
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
                const SizedBox(
                  height: 3,
                ),
                ElevatedButton(
                  onPressed: () {
                    viewIndoorMap(place);
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepOrange),
                      maximumSize:
                          MaterialStateProperty.all(const Size.fromWidth(300))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.map_outlined),
                      Text('View Indoor Map')
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ))
          ]);
        }).whenComplete(() => setState(() => markers.remove(marker)));
  }

  Future<void> getDirections(Place place, TravelMode mode) async {
    Position userPosition = await GeolocatorService().getCurrentLocation();
    LatLng latLngPosStart =
        LatLng(userPosition.latitude, userPosition.longitude);
    Marker startMarker =
        Marker(markerId: const MarkerId('Start'), position: latLngPosStart);

    LatLng latLngPosEnd = place.latLng;

    Marker endMarker =
        Marker(markerId: const MarkerId('End'), position: latLngPosEnd);

    Dio dio = Dio();
    String endLat = latLngPosEnd.latitude.toString();
    String endLng = latLngPosEnd.longitude.toString();
    String stLat = latLngPosStart.latitude.toString();
    String stLng = latLngPosStart.longitude.toString();

    if (mode == TravelMode.driving) {
      setState(() => modeOfTransit = 'driving');
    } else if (mode == TravelMode.walking) {
      setState(() => modeOfTransit = 'walking');
    } else if (mode == TravelMode.transit) {
      setState(() => modeOfTransit = 'transit');
    }

    if (mode == TravelMode.driving || mode == TravelMode.walking) {
      _getPolyline(latLngPosStart, latLngPosEnd, mode);
      Response response = await dio.get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLat,$endLng&origins=$stLat,$stLng&mode=$modeOfTransit&key=AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');

      String distance =
          response.data['rows'][0]['elements'][0]['distance']['text'];
      String duration =
          response.data['rows'][0]['elements'][0]['duration']['text'];

      setState(() {
        totalDistance = distance;
        totalDuration = duration;
        markers = {startMarker, endMarker};
      });
    } else {
      //Transit
      //Get 2 bus stops closest to start
      Position userPosition = await GeolocatorService().getCurrentLocation();
      LatLng latLngPos = LatLng(userPosition.latitude, userPosition.longitude);
      List<Map<String, LatLng>> busStopListStart = getNearestBusStop(latLngPos);

      //Get 2 bus stops closest to end
      List<Map<String, LatLng>> busStopListEnd =
          getNearestBusStop(latLngPosEnd);

      String start1 = busStopListStart[0].keys.first;
      String start2 = busStopListStart[1].keys.first;

      String end1 = busStopListEnd[0].keys.first;
      String end2 = busStopListEnd[1].keys.first;

      List<List<String>>? route0 = findRoute(start1, end1);
      List<List<String>>? route1 = findRoute(start1, end2);
      List<List<String>>? route2 = findRoute(start2, end1);
      List<List<String>>? route3 = findRoute(start2, end2);

      var routes = [route0, route1, route2, route3];
      var valid = [true, true, true, true];

      //do not consider impossible routes
      for (int i = 0; i < 4; i++) {
        if (routes[i].first.isEmpty) {
          valid[i] = false;
        }
      }

      if (valid == [false, false, false, false]) {
        throw Exception('No routes found');
      }

      //find min stops
      int bestRoute = -1;
      for (int i = 0; i < 4; i++) {
        if (valid[i]) {
          if (bestRoute == -1) {
            bestRoute = i;
          } else {
            if (routes[i].length < routes[bestRoute].length) {
              bestRoute = i;
            }
          }
        }
      }

      String? startStop, endStop;
      var route = routes[bestRoute];
      if (bestRoute == 0) {
        startStop = start1;
        endStop = end1;
      } else if (bestRoute == 1) {
        startStop = start1;
        endStop = end2;
      } else if (bestRoute == 2) {
        startStop = start2;
        endStop = end1;
      } else if (bestRoute == 3) {
        startStop = start2;
        endStop = end2;
      }

      print(route);
      print(getBestRoute(route));
      print('Start stop: ' + startStop! + ' End stop: ' + endStop!);

      //check if just walking is faster, assumption: each stop ~ 2 mins
      //Just walking
      Response response = await dio.get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLat,$endLng&origins=$stLat,$stLng&mode=walking&key=AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');
      if (response.data['error_message'] ==
          "You have exceeded your rate-limit for this API.") {
        throw Exception(
            'Cannot get data from Google Distance Matrix API because you have exceeded the rate-limit. Try again later');
      }

      String durationWalkStr =
          response.data['rows'][0]['elements'][0]['duration']['text'];
      int durationWalkInt = int.parse(durationWalkStr.substring(0, 2));

      if (startStop == "Prince George's Park") {
        startStop = "Prince George\'s Park";
      }
      if (startStop == "Prince George's Park Residences") {
        startStop = "Prince George\'s Park Residences";
      }
      if (endStop == "Prince George's Park") {
        endStop = "Prince George\'s Park";
      }
      if (endStop == "Prince George's Park Residences") {
        endStop = "Prince George\'s Park Residences";
      }

      //From start to startStop
      String startStopLat = busStopsLatLng[startStop]!.latitude.toString();
      String startStopLng = busStopsLatLng[startStop]!.longitude.toString();
      response = await dio.get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$startStopLat,$startStopLng&origins=$stLat,$stLng&mode=walking&key=AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');

      if (response.data['error_message'] ==
          "You have exceeded your rate-limit for this API.") {
        throw Exception(
            'Cannot get data from Google Distance Matrix API because you have exceeded the rate-limit. Try again later');
      }
      String durationBus1Str =
          response.data['rows'][0]['elements'][0]['duration']['text'];
      int durationBus1Int = int.parse(durationBus1Str.substring(0, 2));

      //Wait before sending next request, otherwise we will exceed request rate limit
      await Future.delayed(const Duration(milliseconds: 500));

      //From endStop to end
      String endStopLat = busStopsLatLng[endStop]!.latitude.toString();
      String endStopLng = busStopsLatLng[endStop]!.longitude.toString();

      response = await dio.get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLat,$endLng&origins=$endStopLat,$endStopLng&mode=walking&key=AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');

      if (response.data['error_message'] ==
          "You have exceeded your rate-limit for this API.") {
        throw Exception(
            'Cannot get data from Google Distance Matrix API because you have exceeded the rate-limit. Try again later');
      }
      String durationBus2Str =
          response.data['rows'][0]['elements'][0]['duration']['text'];
      int durationBus2Int = int.parse(durationBus2Str.substring(0, 2));

      if (durationWalkInt <
          durationBus1Int + durationBus2Int + 2 * route.length) {
        //Walking is faster, walk
        getDirections(place, TravelMode.walking);
      } else {
        setState(() {
          totalDuration = durationBus1Str;
          totalDuration2 = durationBus2Str;
          markers = {startMarker, endMarker};
          instructions = getBestRoute(route);
        });

        _getPolylineTransit(
            latLngPosStart, latLngPosEnd, startStop, endStop, route);

        markSelectedBusStops([startStop, endStop]);
      }
    }

    floatingSearchBarController.hide();
    visibility = true;
    locateUserPosition();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(
    LatLng start,
    LatLng end,
    TravelMode mode,
  ) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      key,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: mode,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  _getPolylineTransit(LatLng start, LatLng end, String startStop,
      String endStop, List<List<String>> route) async {
    //Points from walking from start to startStop
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      key,
      PointLatLng(start.latitude, start.longitude),
      busStopsLatLng[startStop]!,
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    //Points from startStop to endStop
    //Get route from 1 bus stop to another by getting driving instructions from startStop to its next bus stop,
    //until endStop
    String currStop = startStop;
    String nextStop = "";

    for (List<String> stop in route) {
      //for each stop along the way
      var nextStops = graph[currStop]; //get the list of stops that are next
      for (var busStop in nextStops!) {
        // print(busStop);
        if (busStop["bus"] == stop[0]) {
          nextStop = busStop["nextBusStop"]!; //find the correct next stop
          //Ignore warning. Without the \' dart will call e.g. busStopsLatLng[Prince George] instead
          if (nextStop == "Prince George's Park") {
            nextStop = "Prince George\'s Park";
          }
          if (nextStop == "Prince George's Park Residences") {
            nextStop = "Prince George\'s Park Residences";
          }
          break;
        }
      }

      //print('Curr: $currStop(${busStopsLatLng[currStop]?.longitude}, ${busStopsLatLng[currStop]?.latitude}) , Next: $nextStop(${busStopsLatLng[nextStop]?.longitude}, ${busStopsLatLng[nextStop]?.latitude})');

      result = await polylinePoints.getRouteBetweenCoordinates(
        key,
        busStopsLatLng[currStop]!,
        busStopsLatLng[nextStop]!,
        travelMode: TravelMode.driving,
      ); //get driving instructions to the next stop

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } //add polyline
      else {
        throw Exception('Cannot find route from $currStop to $nextStop');
      }

      currStop = nextStop;
    }

    //Points from walking from endStop to end
    result = await polylinePoints.getRouteBetweenCoordinates(
      key,
      busStopsLatLng[endStop]!,
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  void viewIndoorMap(Place place) {
    if (place.indoorMap != null) {
      var newScreen = place.indoorMap;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => newScreen!));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Indoor Map not Available'),
                content:
                    Text('Indoor map for ${place.name} is not available yet.'),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'))
                ],
              ));
    }
    //ToDo: navigate to indoor map
  }

  Widget buildDirections() {
    return Positioned(
        bottom: 0,
        child: Visibility(
            visible: visibility, // Set it to false
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 125,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.grey[300],
                ),
                child: Stack(children: [
                  Column(children: [
                    Center(
                      child: Text(
                        destination.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (modeOfTransit == 'walking' && visibility) ...[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[400],
                              ),
                              child: Wrap(
                                children: [
                                  const Icon(
                                    Icons.directions_walk,
                                    size: 20,
                                  ),
                                  Text(
                                    totalDuration,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            )
                          ])
                    ] else if (modeOfTransit == 'driving' && visibility) ...[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[400],
                              ),
                              child: Wrap(
                                children: [
                                  const Icon(Icons.directions_car),
                                  Text(
                                    totalDuration,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            )
                          ])
                    ] else if (modeOfTransit == 'transit' && visibility) ...[
                      Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                children: [
                                  //Walk to nearest bus stop(s)
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[400],
                                    ),
                                    child: Wrap(
                                      children: [
                                        const Icon(
                                          Icons.directions_walk,
                                          size: 20,
                                        ),
                                        Text(
                                          totalDuration,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(Icons.keyboard_arrow_right_sharp),

                                  //Bus, use bus_directions_service
                                  BusDirections(instructions: instructions),
                                  //Walk to destination
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[400],
                                    ),
                                    child: Wrap(
                                      children: [
                                        const Icon(
                                          Icons.directions_walk,
                                          size: 20,
                                        ),
                                        Text(
                                          totalDuration2,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                    if (BusDirections(instructions: instructions).getLength() >=
                        3) ...[
                      const SizedBox(height: 5),
                      const Text("<<< Scroll >>>",
                          style: TextStyle(color: Colors.black54))
                    ]
                  ]),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Icon(Icons.close),
                      onPressed: () {
                        closeDirections();
                      },
                    ),
                  )
                ]))));
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

  // calculate distance with latitude and longitude values
  double calculateDistance(lat1, lon1, lat2, lon2) {
    const GDistance distance = GDistance();
    final double meter =
        distance(GeoLatLng(lat1, lon1), GeoLatLng(lat2, lon2)) as double;
    return meter;
  }

  // Get a list of two Nearest Bus stops based on the given location
  // sample output: [{University Town: LatLng(1., 103.)}, {Museum: LatLng(1., 103.)}]
  List<Map<String, LatLng>> getNearestBusStop(LatLng givenLocation) {
    List<Map<String, double>> distances = [];

    busStopsLatLng.forEach((key, value) {
      double currDist = calculateDistance(givenLocation.latitude,
          givenLocation.longitude, value.latitude, value.longitude);

      distances.add({key: currDist});
    });

    String firstName = '';
    String secondName = '';
    double firstDistance = 10000;
    double secondDistance = 10000;

    for (Map<String, double> stop in distances) {
      if (stop.values.first < firstDistance) {
        secondDistance = firstDistance;
        secondName = firstName;
        firstDistance = stop.values.first;
        firstName = stop.keys.first;
      } else if (stop.values.first < secondDistance &&
          stop.values.first != firstDistance) {
        secondDistance = stop.values.first;
        secondName = stop.keys.first;
      }
    }

    LatLng firstLocation = LatLng(busStopsLatLng[firstName]!.latitude,
        busStopsLatLng[firstName]!.longitude);
    LatLng secondLocation = LatLng(busStopsLatLng[secondName]!.latitude,
        busStopsLatLng[secondName]!.longitude);

    List<Map<String, LatLng>> result = [
      {firstName: firstLocation},
      {secondName: secondLocation}
    ];
    return result;
  }

  // Map Function to Mark the nearest two bus stops on the map based on user's location.
  void markBusStops() async {
    BitmapDescriptor busIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/icons/bus.png');
    try {
      Position userPosition = await GeolocatorService().getCurrentLocation();
      LatLng latLngPos = LatLng(userPosition.latitude, userPosition.longitude);
      List<Map<String, LatLng>> busStopList = getNearestBusStop(latLngPos);
      for (Map<String, LatLng> busStop in busStopList) {
        setState(() {
          markers.add(Marker(
              markerId: MarkerId(busStop.keys.first),
              position: busStop.values.first,
              icon: busIcon));
        });
      }
    } catch (error) {
      print(error);
    }
  }

  // Map Function to Mark the nearest two bus stops on the map based on given location.
  void markLocationBusStops(LatLng location) async {
    BitmapDescriptor busIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/icons/bus.png');
    try {
      List<Map<String, LatLng>> busStopList = getNearestBusStop(location);
      setState(() {
        markers.clear();
        markers.add(Marker(
            markerId: const MarkerId("Destination"), position: location));
      });
      for (Map<String, LatLng> busStop in busStopList) {
        setState(() {
          markers.add(Marker(
              markerId: MarkerId(busStop.keys.first),
              position: busStop.values.first,
              icon: busIcon));
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void markSelectedBusStops(List<String> locations) async {
    BitmapDescriptor busIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/icons/bus.png');
    for (String location in locations) {
      if (location == "Prince George's Park") {
        location = "Prince George\'s Park";
      }
      if (location == "Prince George's Park Residences") {
        location = "Prince George\'s Park Residences";
      }
      try {
        setState(() {
          markers.add(Marker(
              markerId: MarkerId(location),
              position: LatLng(busStopsLatLng[location]!.latitude,
                  busStopsLatLng[location]!.longitude),
              icon: busIcon));
        });
      } catch (error) {
        print(error);
      }
    }
  }
}
//<a target="_blank" href="https://icons8.com/icon/SIvn6TBf7q6F/bus-stop">Bus Stop</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>