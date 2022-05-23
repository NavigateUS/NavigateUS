import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigateus/mapFunctions/place_service.dart';
import 'package:navigateus/screens/map_screen.dart';

//https://pub.dev/packages/material_floating_search_bar

// Widget buildFloatingSearchBar(context) {
//   final FloatingSearchBarController floatingSearchBarController =
//       FloatingSearchBarController();
//
//   final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//
//   return FloatingSearchBar(
//     hint: 'Where would you like to go?',
//     controller: floatingSearchBarController,
//     automaticallyImplyDrawerHamburger: true,
//     scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
//     transitionDuration: const Duration(milliseconds: 300),
//     transitionCurve: Curves.bounceInOut,
//     physics: const BouncingScrollPhysics(),
//     axisAlignment: isPortrait ? 0.0 : -1.0,
//     openAxisAlignment: 0.0,
//     debounceDelay: const Duration(milliseconds: 500),
//     onQueryChanged: (query) {
//       print(query);
//     },
//     onSubmitted: (query) async {
//       // Map<String, dynamic> data = {
//       //   "p": {
//       //     "geometry": {
//       //       "location": {"lat": 22.572646, "lng": 88.36389500000001}
//       //     }
//       //   }
//       // };
//       // print(data);
//       // floatingSearchBarController.close();
//       // MapState().goToPlace(data);
//       var place = await PlaceService().getPlace(query);
//       MapState().goToPlace(place);
//     },
//     actions: [
//       FloatingSearchBarAction.searchToClear(
//         showIfClosed: false,
//       ),
//     ],
//     builder: (context, transition) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Material(
//           color: Colors.white,
//           elevation: 4.0,
//
//           //Child: This is whatever shows up below the search bar
//           child: Column(mainAxisSize: MainAxisSize.min),
//         ),
//       );
//     },
//   );
// }
