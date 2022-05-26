import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreen extends StatelessWidget {
  final String floor;
  final String image;

  const DetailScreen({Key? key, required this.floor, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(floor), backgroundColor: Colors.deepOrange),
        body: PhotoView(
          imageProvider: AssetImage(image),
        ));
  }
}
