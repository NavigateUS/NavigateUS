import 'package:flutter/material.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';

class IndoorMap extends StatefulWidget {
  const IndoorMap({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => IndoorMapState();
}

class IndoorMapState extends State {
  final controller = TextEditingController();
  final List<ImageButton> allBuildings = const [
    ImageButton(
      name: "COM1",
      image: "assets/indoor_maps/COM1_Cover.jpg",
      newScreen:
          FloorMap(building: "COM1", floorList: ['Basement', 'L1', 'L2', 'L3']),
    ),
    ImageButton(
      name: "COM2",
      image: "assets/indoor_maps/COM2_Cover.jpg",
      newScreen: FloorMap(
          building: "COM2", floorList: ['Basement', 'L1', 'L2', 'L3', 'L4']),
    ),
    ImageButton(
      name: "AS3",
      image: "assets/indoor_maps/AS3_Cover.jpg",
      newScreen: FloorMap(building: "AS3", floorList: ['L6']),
    ),
    ImageButton(
        name: "AS6",
        image: "assets/indoor_maps/AS6_Cover.jpg",
        newScreen: FloorMap(building: "AS6", floorList: ['L2', 'L4', 'L5'])),
    ImageButton(
      name: "ICUBE",
      image: "assets/indoor_maps/ICUBE_Cover.jpg",
      newScreen: FloorMap(building: "ICUBE", floorList: ['L1', 'L3']),
    )
  ];

  List<ImageButton> selectedBuildings = [];

  @override
  initState() {
    // at the beginning, all are shown
    selectedBuildings = allBuildings;
    super.initState();
  }

  // This function is called whenever the text field changes
  void searchBuilding(String enteredKeyword) {
    List<ImageButton> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all buildings
      results = allBuildings;
    } else {
      results = allBuildings
          .where((button) =>
              button.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      selectedBuildings = results;
    });
  }

  // Indoor Map page with buttons of school buildings
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Indoor Maps"),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search Building",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.blue))),
                  onChanged: (value) => searchBuilding(value),
                )),
            Column(children: selectedBuildings),
          ],
        ),
      ),
    );
  }
}
