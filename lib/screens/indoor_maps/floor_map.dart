import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FloorMap extends StatefulWidget {
  final String building;
  final List<String> floorList;

  const FloorMap({Key? key, required this.building, required this.floorList})
      : super(key: key);

  @override
  FloorMapState createState() => FloorMapState();
}

class FloorMapState extends State<FloorMap> {
  late String building;
  late String imagePath;
  late String floor;
  late List<String> floorList;

  @override
  void initState() {
    super.initState();
    building = widget.building;
    floorList = widget.floorList;
    floor = floorList[0];
    imagePath = "assets/indoor_maps/${building}_$floor.jpg";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(building),
          backgroundColor: Colors.deepOrange,
        ),
        body: Stack(alignment: Alignment.center, children: [
          PhotoView(imageProvider: AssetImage(imagePath)),
          Positioned(
            top: 40,
            child: (Text(
              floor,
              style: const TextStyle(color: Colors.white, fontSize: 35),
            )),
          ),
          Positioned(
              bottom: 40,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (String label in floorList)
                      labelButton(
                          label, "assets/indoor_maps/${building}_$label.jpg"),
                  ]))
        ]));
  }

  Widget labelButton(String label, String image) {
    return FloatingActionButton(
        mini: true,
        shape: const RoundedRectangleBorder(),
        child: Text(
          textConvert(label),
          style: const TextStyle(fontSize: 20),
        ),
        onPressed: () {
          setState(() {
            floor = label;
            imagePath = image;
          });
        });
  }

  String textConvert(String text) {
    if (text == "Basement") {
      return "B";
    }
    return text;
  }
}
