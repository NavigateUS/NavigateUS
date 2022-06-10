import 'package:flutter/material.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';

class IndoorMap extends StatelessWidget {
  const IndoorMap({Key? key}) : super(key: key);

  // Indoor Map page with buttons of school buildings
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Indoor Maps"),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
            child: Column(children: const [
          ImageButton(
            name: "COM1",
            image: "assets/indoor_maps/COM1_Cover.jpg",
            newScreen:
                FloorMap(building: "COM1", floorNum: 3, hasBasement: true),
          ),
          ImageButton(
            name: "COM2",
            image: "assets/indoor_maps/COM2_Cover.jpg",
            newScreen:
                FloorMap(building: "COM2", floorNum: 4, hasBasement: true),
          ),
        ])));
  }
}

// class IndoorMap extends StatelessWidget {
//   IndoorMap({Key? key}) : super(key: key);

//   final controller = TextEditingController();
//   List<Building> buildings = allBuildings;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Indoor Maps"),
//           backgroundColor: Colors.deepOrange,
//         ),
//         body: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//               child: TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.search),
//                     hintText: "Building Name",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: const BorderSide(color: Colors.blue))),
//                 onChanged: searchBuilding,
//               ),
//             ),
//             ListView.builder(itemBuilder: ((context, index) {
//               final building = buildings[index];
//               return ListTile(
//                   leading: ImageButton(
//                 name: building.name,
//                 image: building.image,
//                 newScreen: building.newScreen,
//               ));
//             })),
//             SingleChildScrollView(
//                 child: Column(children: const [
//               ImageButton(
//                 name: "COM1",
//                 image: "assets/indoor_maps/COM1_Cover.jpg",
//                 newScreen:
//                     FloorMap(building: "COM1", floorNum: 3, hasBasement: true),
//               ),
//               ImageButton(
//                 name: "COM2",
//                 image: "assets/indoor_maps/COM2_Cover.jpg",
//                 newScreen:
//                     FloorMap(building: "COM2", floorNum: 4, hasBasement: true),
//               ),
//             ])),
//           ],
//         ));
//   }

//   void searchBuilding(String query) {
//     final suggestions = allBuildings.where((building) {
//       final buildingName = building.name.toLowerCase();
//       final input = query.toLowerCase();
//       return buildingName.contains(input);
//     }).toList();
//     buildings = suggestions;
//   }
// }



