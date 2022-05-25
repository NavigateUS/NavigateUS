import 'package:flutter/material.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/detail_screen.dart';

class FloorMap extends StatelessWidget {
  final String building;
  final int floorNum;
  final bool hasBasement;

  const FloorMap({
    Key? key,
    required this.building,
    required this.floorNum,
    required this.hasBasement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> textList = [];

    for (int i = floorNum; i > 0; i--) {
      textList.add("L$i");
    }

    if (hasBasement) {
      textList.add("Basement");
    }

    return Scaffold(
        appBar: AppBar(title: Text(building),
                      backgroundColor: Colors.deepOrange,),
        body: SingleChildScrollView(
            child: Column(children: [
          for (String floor in textList)
            ImageButton(
              name: floor,
              image: "assets/indoor_maps/$building\_$floor.jpg",
              newScreen: DetailScreen(
                  image: "assets/indoor_maps/$building\_$floor.jpg"),
            ),
        ])));
  }
}
