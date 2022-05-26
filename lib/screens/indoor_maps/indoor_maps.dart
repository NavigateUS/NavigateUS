import 'package:flutter/material.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';

class IndoorMap extends StatelessWidget {
  const IndoorMap({Key? key}) : super(key: key);

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
