import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class BusPage extends StatelessWidget {
  final String service;

  const BusPage({Key? key, required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service),
        backgroundColor: Colors.deepOrange,),
      body: PhotoView(imageProvider: AssetImage('assets/bus_routes/$service.jpg'),),
      );
  }
}
