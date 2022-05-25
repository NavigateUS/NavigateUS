import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigateus/mapFunctions/place_service.dart';
import 'package:navigateus/screens/map_screen.dart';

//https://pub.dev/packages/material_floating_search_bar

class FloatingSearchBarWidget extends StatefulWidget {
  const FloatingSearchBarWidget({Key? key}) : super(key: key);

  @override
  State<FloatingSearchBarWidget> createState() => _FloatingSearchBarWidgetState();
}

class _FloatingSearchBarWidgetState extends State<FloatingSearchBarWidget> {
  final FloatingSearchBarController floatingSearchBarController =
  FloatingSearchBarController();
  GooglePlace googlePlace = GooglePlace('AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');
  List<AutocompletePrediction> predictions = [];

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      print(result.predictions!.first.description);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void goToPlace (index) async {
    final placeID = predictions[index].placeId!;
    final details = await googlePlace.details.get(placeID);
    if (details != null && details.result != null) {
      double? lat = details.result!.geometry!.location!.lat;
      double? lng = details.result!.geometry!.location!.lng;
      LatLng latLngPos = LatLng(lat!, lng!);
      MapState().goToPlace(latLngPos);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Where would you like to go?',
      controller: floatingSearchBarController,
      automaticallyImplyDrawerHamburger: true,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transition: ExpandingFloatingSearchBarTransition(),
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
          print(predictions.length);
        }
        else {
          setState(() {
            predictions = [];
          });
        }
      },
      onSubmitted: (query) async {
        goToPlace(0);
      },
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
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
                  title: Text(predictions[index].description.toString()),
                  onTap: () {
                    goToPlace(index);
                  },
                );
              },
            ),
          ),
        );
      },
    );;
  }
}



