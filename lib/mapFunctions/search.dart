import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:navigateus/screens/map_screen.dart';
import 'dart:async';


//https://www.youtube.com/watch?v=zly4p_mmogI&t=360s
//https://pub.dev/packages/google_place

Widget buildSearch() {
  TextEditingController searchController = TextEditingController();
  GooglePlace googlePlace = GooglePlace('AIzaSyBnZTJifjfYwB34Y2rhF-HyQW2rYPcxysM');
  List<AutocompletePrediction> predictions = [];
  Timer? debounce;

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      print(result.predictions!.first.description);
      predictions = result.predictions!;
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

  return Column(
    children: <Widget>[
      Row(
        children: [
          Expanded(child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(hintText: 'Where to?'),
            onChanged: (value) {
              if (debounce?.isActive ?? false) {
                debounce!.cancel();
              }

              debounce = Timer(const Duration(milliseconds: 500), () {
                if (value.isNotEmpty) {
                  //places api
                  autoCompleteSearch(value);
                }
                else {
                  //clear
                }
              });
            },
          )),
          IconButton(
            onPressed: () {
              goToPlace(0);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      ListView.builder(
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
      )
    ]
  );
}

