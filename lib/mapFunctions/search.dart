import 'package:flutter/material.dart';
import 'package:navigateus/mapFunctions/place_service.dart';
import 'package:navigateus/screens/map_screen.dart';

Widget buildSearch() {
  TextEditingController _searchController = TextEditingController();

  return Row(
    children: [
      Expanded(child: TextFormField(
        controller: _searchController,
        decoration: const InputDecoration(hintText: 'Where to?'),
        onChanged: (value) {
          print(value);
        },
      )),
      IconButton(
        onPressed: () {
          PlaceService().getPlaceId(_searchController.text);
        },
        icon: const Icon(Icons.search),
      ),
    ],
  );
}