import 'package:flutter/material.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';

class Building {
  final String name;
  final String image;
  final Widget newScreen;

  const Building({
    required this.name,
    required this.image,
    required this.newScreen,
  });
}

// A list of school buildings, not used yet.
const allBuildings = [
  Building(
    name: "COM1",
    image: "assets/indoor_maps/COM1_Cover.jpg",
    newScreen: FloorMap(building: "COM1", floorNum: 3, hasBasement: true),
  ),
  Building(
    name: "COM2",
    image: "assets/indoor_maps/COM2_Cover.jpg",
    newScreen: FloorMap(building: "COM2", floorNum: 4, hasBasement: true),
  ),
];
