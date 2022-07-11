import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/detail_screen.dart';
import 'package:photo_view/photo_view.dart';

class FloorMap extends StatefulWidget {
  final String building;

  const FloorMap({Key? key, required this.building}) : super(key: key);

  @override
  FloorMapState createState() => FloorMapState();
}

class FloorMapState extends State<FloorMap> {
  late String building;
  List<String> floors = [];
  List file = [];

  @override
  void initState() {
    super.initState();
    building = widget.building;
    // getImageList();
    listofFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(building),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(children: <Widget>[
          // your Content if there
          Expanded(
              child: ListView.builder(
                  itemCount: file.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(file[index].path);
                  }))
        ]));
  }

  List<Widget> buildButton() {
    List<Widget> list = [];
    for (String path in floors) {
      list.add(Row(children: [Text(path)]));
    }
    return list;
  }

  // Read images in the folder, select the images belongs to the building, exclude cover.

  // sort image list based on reversed alphabetical order, L3, L2, B

  // Create list of button based on the list of floor image.

  // connect button with the image viewer.

  void listofFiles() async {
    Directory directory = await getApplicationDocumentsDirectory();
    setState(() {
      // file = Directory("$directory/assets/indoor_maps/")
      //     .listSync();
      file = directory.listSync(followLinks: true);
    });
    print(file);
  }

  // void getImageList() async {
  //   await for (var entity in path.list(recursive: true, followLinks: false)) {
  //     String file = entity.toString();
  //     if (file.contains(building)) {
  //       if (!file.contains('Cover')) {
  //         floors.add(entity.toString());
  //         print(file);
  //         print(floors.toString());
  //       }
  //     }
  //   }
  // }
}
