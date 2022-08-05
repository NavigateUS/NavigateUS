import 'dart:async';
import 'dart:core';
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
import 'package:navigateus/bus_data/bus_stop_latlng2.dart';
import 'package:navigateus/key.dart';
import 'package:navigateus/screens/map/widgets/bus_directions.dart';
import 'package:navigateus/places.dart';
import 'package:geopointer/geopointer.dart';
import 'package:navigateus/screens/map/widgets/bus_tile.dart';
import 'package:navigateus/screens/map/widgets/detailed_directions.dart';
import 'package:navigateus/screens/timetable/components/data_source.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/timetable_screen.dart';
import 'package:collection/collection.dart';
import 'package:navigateus/screens/timetable/timetable_storage.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapState();
}

//For use in finding directions
class BusStop {
  late final String name;
  late final LatLng latLng;
  late final int time;

  BusStop(this.name, this.latLng) {
    if (name == "Prince George's Park") {
      name = "Prince George\'s Park";
    }
    if (name == "Prince George's Park Residences") {
      name = "Prince George\'s Park Residences";
    }
  }

  void setTime (int time) {
    this.time = time;
  }
}


class BusRoute {
  late final List<List<String>> route;
  late final String start;
  late final String end;
  late bool valid;
  late int time;

  BusRoute(this.route, this.start, this.end) {
    valid = true;
  }

  void invalidate() {
    valid = false;
  }

  void setTime (int time) {
    this.time = time;
  }
}

class MapState extends State<MapScreen> {
  String apiKey = key;
  final Completer<GoogleMapController> _controller = Completer();
  final FloatingSearchBarController floatingSearchBarController =
      FloatingSearchBarController();
  late GooglePlace googlePlace = GooglePlace(apiKey);
  bool hasData = false;
  List<Place> predictions = [];
  Map<Place, String> predictions2 = {};
  List<List<String>> predictionClasses = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  bool visibility = false;  //visibility of directions
  bool detailedDirections = false;  //visibility of detailed directions and floating action button
  Place destination = Place('NUS', const LatLng(1.2966, 103.7764));
  String totalDistance = '';
  String totalDuration = '';
  String modeOfTransit = '';
  String totalDuration2 = '';
  String startBusStop = '';
  late List<DirectionInstructions> instructions = [];
  late StreamSubscription<Position>? locationStream;
  late List<Module> appointments;
  DataSource moduleDataSource = DataSource(modules);
  TimetableStorage storage = TimetableStorage();

  @override
  void initState() {
    super.initState();
    storage.readTimetable().then((value) {
      setState(() {
        modules = value;
        appointments = modules;
        moduleDataSource = DataSource(appointments);
      });
    });
  }

  // Page Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Listener(
            onPointerDown: (drag) {
              locationStream?.cancel();
            },
            child: Stack(children: [
              buildMap(),
              buildSearchBar(context),
              buildDirections(),
            ])),
        drawer: buildDrawer(context),
        floatingActionButton: detailedDirections
            ? null
            : Padding(
              padding: visibility
                  ? const EdgeInsets.only(bottom: 120)
                  : const EdgeInsets.only(bottom: 0),
              child: FloatingActionButton(
                  child: const Icon(Icons.location_searching),
                  onPressed: () {
                    locateUserPosition();
                  }),
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
      polylines: polylines,
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
      rethrow;
    }
  }

  void goToPlace(LatLng latLngPos) async {
    try {
      GoogleMapController controller = await _controller.future;
      CameraPosition pos = CameraPosition(target: latLngPos, zoom: 17);
      controller.animateCamera(CameraUpdate.newCameraPosition(pos));
    } catch (error) {
      rethrow;
    }
  }

  void autoCompleteSearch(String query) {
    final suggestions = nusLocations.values.where((place) {
      final name = place.name.toLowerCase();
      final input = query.toLowerCase();

      return name.contains(input);
    }).toList();

    setState(() => predictions = suggestions);
  }

  // Search Bar
  Widget buildSearchBar(BuildContext context) {
    // Search Bar Functions
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    void resetPredictions() {
      setState(() {
        predictions2 = moduleDataSource.getPlaces();
        predictions = predictions2.keys.toList();
      });
    }

    return FloatingSearchBar(
      hint: 'Where would you like to go?',
      controller: floatingSearchBarController,
      automaticallyImplyDrawerHamburger: true,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transition: SlideFadeFloatingSearchBarTransition(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      iconColor: Colors.deepOrange,
      onFocusChanged: (apiKey) async{  //apiKey can be replaced by anything that results in true
        await Future.delayed(const Duration(milliseconds: 100));
        resetPredictions();
      },
      onQueryChanged: (value) async {
        if (value.isNotEmpty) {
          //places api
          autoCompleteSearch(value);
        } else {
          resetPredictions();
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
                  subtitle: predictions2.containsKey(predictions[index])
                            ? Text(predictions2[predictions[index]]!)
                            : const Text(""),
                  onTap: () async {
                    var place = predictions[index];
                    LatLng position = place.latLng;
                    goToPlace(position);
                    floatingSearchBarController.close();
                    bottomSheet(context, place);
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
    print(place);
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
                            key: const Key('Walk'),
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
                            key: const Key('Drive'),
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
                            key: const Key('Transit'),
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
                      key: const Key('Indoor'),
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
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLat,$endLng&origins=$stLat,$stLng&mode=$modeOfTransit&key=$apiKey');

      print('a');
      print(response.data);

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

      //Get 4 bus stops in a map
      String start1 = busStopListStart[0].keys.first;
      LatLng start1LatLng = busStopListStart[0].values.first;

      String start2 = busStopListStart[1].keys.first;
      LatLng start2LatLng = busStopListStart[1].values.first;

      String end1 = busStopListEnd[0].keys.first;
      LatLng end1LatLng = busStopListEnd[0].values.first;

      String end2 = busStopListEnd[1].keys.first;
      LatLng end2LatLng = busStopListEnd[1].values.first;

      Map<String, BusStop> busstops = {
        "Start1" : BusStop(start1, start1LatLng),
        "Start2" : BusStop(start2, start2LatLng),
        "End1" : BusStop(end1, end1LatLng),
        "End2" : BusStop(end2, end2LatLng)
      };

      //Get walk time to all 4 bus stops
      Response response;

      for (MapEntry entry in busstops.entries) {
        String K = entry.key;
        BusStop V = entry.value;

        LatLng otherLatLng;
        if (K == "Start1" || K == "Start2") {
          otherLatLng = latLngPosStart;
        }
        else {
          otherLatLng = latLngPosEnd;
        }

        response = await dio.get(
            'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${V.latLng.latitude.toString()},${V.latLng.longitude.toString()}&origins=${otherLatLng.latitude.toString()},${otherLatLng.longitude.toString()}&mode=walking&key=$apiKey');

        if (response.data['error_message'] ==
            "You have exceeded your rate-limit for this API.") {
          throw Exception(
              'Cannot get data from Google Distance Matrix API because you have exceeded the rate-limit. Try again later');
        }

        String duration =
        response.data['rows'][0]['elements'][0]['duration']['text'];
        int durationInt = int.parse(duration.substring(0, 2));
        V.setTime(durationInt);

        BusStop temp = V;
        busstops.update(K, (value) => temp);


        //Wait before sending next request, otherwise we will exceed request rate limit
        await Future.delayed(const Duration(milliseconds: 100));
      }


      List<List<String>>? route0 = findRoute(busstops["Start1"]!.name, busstops["End1"]!.name);
      List<List<String>>? route1 = findRoute(busstops["Start1"]!.name, busstops["End2"]!.name);
      List<List<String>>? route2 = findRoute(busstops["Start2"]!.name, busstops["End1"]!.name);
      List<List<String>>? route3 = findRoute(busstops["Start2"]!.name, busstops["End2"]!.name);

      var routes = [BusRoute(route0, "Start1", "End1"), BusRoute(route1, "Start1", "End2"), BusRoute(route2, "Start2", "End1"), BusRoute(route3, "Start2", "End2")];
      int invalid = 0;

      //do not consider impossible routes
      for (int i = 0; i < 4; i++) {
        if (routes[i].route.first.isEmpty) {
          routes[i].invalidate();
          invalid++;
        }
      }

      if (invalid == 4) {
        throw Exception('No routes found');
      }


      //For each valid route, calculate time taken, assumption: each stop ~ 2 mins, and take shortest time
      BusRoute bestRoute = routes[0];

      for (BusRoute busRoute in routes) {
        int time = busstops[busRoute.start]!.time + busstops[busRoute.end]!.time + 2 * busRoute.route.length;
        busRoute.setTime(time);

        if (time < bestRoute.time) {
          bestRoute = busRoute;
        }
      }


      //check if just walking is faster
      response = await dio.get(
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$endLat,$endLng&origins=$stLat,$stLng&mode=walking&key=$apiKey');
      if (response.data['error_message'] ==
          "You have exceeded your rate-limit for this API.") {
        throw Exception(
            'Cannot get data from Google Distance Matrix API because you have exceeded the rate-limit. Try again later');
      }

      String durationWalkStr =
          response.data['rows'][0]['elements'][0]['duration']['text'];
      int durationWalkInt = int.parse(durationWalkStr.substring(0, 2));


      if (durationWalkInt < bestRoute.time) {
        //Walking is faster, walk
        getDirections(place, TravelMode.walking);
      }
      else {
        setState(() {
          if (busstops[bestRoute.start]!.time == 1) {
            totalDuration = '${busstops[bestRoute.start]!.time} min';
          }
          else {
            totalDuration = '${busstops[bestRoute.start]!.time} mins';
          }

          if (busstops[bestRoute.end]!.time == 1) {
            totalDuration2 = '${busstops[bestRoute.end]!.time} min';
          }
          else {
            totalDuration2 = '${busstops[bestRoute.end]!.time} mins';
          }

          markers = {startMarker, endMarker};

          instructions = getBestRoute(bestRoute.route, busstops[bestRoute.start]!.name);
          startBusStop = busstops[bestRoute.start]!.name;
        });

        _getPolylineTransit(
            latLngPosStart, latLngPosEnd, busstops[bestRoute.start]!.name, busstops[bestRoute.end]!.name, bestRoute.route);

        markSelectedBusStops([busstops[bestRoute.start]!.name, busstops[bestRoute.end]!.name]);

      }
    }

    floatingSearchBarController.hide();
    visibility = true;
    locateUserPosition();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5);
    setState(() {
      polylines.add(polyline);
    });
  }

  _addMultiPolyLine(Set<Polyline> polylineSet) {
    setState(() {
      polylines.addAll(polylineSet);
    });
  }

  _getPolyline(
    LatLng start,
    LatLng end,
    TravelMode mode,
  ) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
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

    Set<Polyline> polylineSet = {};

    //Points from walking from start to startStop
    List<LatLng> polylineCoordinatesStart = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(start.latitude, start.longitude),
      busStopsLatLng[startStop]!,
      travelMode: TravelMode.walking,
    );


    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinatesStart.add(LatLng(point.latitude, point.longitude));
      }
    }

    final newPolyline = Polyline(
      polylineId: const PolylineId("walk"),
      color: Colors.blue,
      points: polylineCoordinatesStart,
      width: 5,
    );


    polylineSet.add(newPolyline);


    //Points from startStop to endStop
    //Get route from 1 bus stop to another by getting driving instructions from startStop to its next bus stop,
    //until endStop
    List<LatLng> polylineCoordinatesMid = [];
    List<Polyline> midPolylines = [];
    String currStop = startStop;
    String nextStop = "";
    int lastStop = 0;
    List<int> segments = [];
    int counter = 0;

    //Calculate stop number to change bus
    for (DirectionInstructions instruction in instructions) {
      int stops = instruction.stops + segments.sum;
      if (segments.sum == 0 && instruction.stops == 1) {
        stops--;
      }
      segments.add(stops);
    }


    for (int i = 0; i < route.length; i++) {
      var stop = route[i];
      //for each stop along the way
      var nextStops = graph[currStop]; //get the list of stops that are next
      for (var busStop in nextStops!) {
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


      result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        busStopsLatLng[currStop]!,
        busStopsLatLng[nextStop]!,
        travelMode: TravelMode.driving,
      ); //get driving instructions to the next stop

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinatesMid.add(LatLng(point.latitude, point.longitude));
        }
      } //add polyline
      else {
        throw Exception('Cannot find route from $currStop to $nextStop');
      }


      if (i == route.length - 1 || i == segments[counter]) {
        Color col = busColor('');
        if (instructions[counter].bus.length == 1) {
          col = busColor(instructions[counter].bus[0]);
        }
        midPolylines.add(
            Polyline(
              polylineId: PolylineId("bus$counter"),
              color: col,
              points: polylineCoordinatesMid.sublist(lastStop, polylineCoordinatesMid.length),
              width: 5,
            )
        );

        lastStop = polylineCoordinatesMid.length;
        counter++;
      }

      currStop = nextStop;
    }


    polylineSet.addAll(midPolylines);

    //Points from walking from endStop to end
    List<LatLng> polylineCoordinatesEnd= [];

    result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      busStopsLatLng[endStop]!,
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinatesEnd.add(LatLng(point.latitude, point.longitude));
      }
    }

    final endPolyline = Polyline(
      polylineId: const PolylineId("walk2"),
      color: Colors.blue,
      points: polylineCoordinatesEnd,
      width: 5,
    );

    polylineSet.add(endPolyline);
    _addMultiPolyLine(polylineSet);
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
  }

  Widget buildDirections() {
    return Positioned(
          bottom: 0,
          child: Visibility(
              visible: visibility, // Set it to false
              child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    int sensitivity = 3;
                    if (details.delta.dy > sensitivity) {
                      // Down Swipe
                      setState(() {
                        detailedDirections = false;
                      });
                    } else if(details.delta.dy < -sensitivity){
                      // Up Swipe
                      setState(() {
                        detailedDirections = true;
                      });
                    }
                  },
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300],
                      ),
                      child: Column(
                          children: [
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
                                    ]
                                )
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
                            ],
                            ),
                            Visibility(
                              visible: detailedDirections && modeOfTransit == 'transit',
                              child: DetailedDirections(instructions: instructions, startStop: startBusStop, destination: destination.name,),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(10),
                                ),
                                child: const Icon(Icons.close),
                                onPressed: () {
                                  closeDirections();
                                  locationStream?.cancel();
                                },
                              ),
                            )
                          ])),
                ),
              )
          ),
    );
  }

  void closeDirections() {
    floatingSearchBarController.show();
    setState(() {
      visibility = false;
      detailedDirections = false;
      polylines = {};
      markers = {};
      polylineCoordinates = [];
      instructions = [];
      startBusStop = '';
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


  //Marks bus stops given (String of bus stop names)
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
        rethrow;
      }
    }
  }
}
//<a target="_blank" href="https://icons8.com/icon/SIvn6TBf7q6F/bus-stop">Bus Stop</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>