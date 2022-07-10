import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/detail_screen.dart';
import 'package:photo_view/photo_view.dart';

class FloorMap extends StatefulWidget {
  final String building;

  const FloorMap({Key? key, required this.building}) : super(key: key);

  @override
  _FloorMapState createState() => _FloorMapState();
}

class _FloorMapState extends State<FloorMap> {
  late String building;
  List<String> floors = [];
  Directory path = Directory("assets/indoor_maps/");

  @override
  void initState() {
    building = widget.building;
    getImageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(building),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: buildButton(),
        ));
  }

  List<Widget> buildButton() {
    List<Widget> list = [];
    for (String path in floors) {
      list.add(Row(children: [Text(path)]));
    }
    return list;
  }

  void getImageList() async {
    await for (var entity in path.list(recursive: true, followLinks: false)) {
      String file = entity.toString();
      if (file.contains(building)) {
        if (!file.contains('Cover')) {
          floors.add(entity.toString());
          print(file);
          print(floors.toString());
        }
      }
    }
  }
}
