import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigateus/bus_data/mock_bus_arrival.dart';

class DetailedDirectionsRow extends StatefulWidget {
  final String stops;
  final String service;
  final int number;
  final String board;
  final String alight;

  const DetailedDirectionsRow({
    Key? key,
    required this.stops,
    required this.service,
    required this.number,
    required this.board,
    required this.alight
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailedDirectionsRowState();
}

class DetailedDirectionsRowState extends State<DetailedDirectionsRow>{
  late Future<Response> arriveData;

  @override
  void initState() {
    super.initState();

    String service = super.widget.service;
    String board = super.widget.board;

    List<String> services = service.split('/');
    arriveData = getArrival(board, services);
  }

  @override
  Widget build(BuildContext context) {
    String stops = super.widget.stops;
    String service = super.widget.service;
    int number = super.widget.number;
    String board = super.widget.board;
    String alight = super.widget.alight;

    List<String> services = service.split('/');

    return FutureBuilder<Response?>(
      future: arriveData,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          Response data = snapshot.data!;

          String stopsTaken = stops;
          stopsTaken += ' ';
          if (int.parse(stops) == 1) {
            stopsTaken += 'stop';
          }
          else{
            stopsTaken += 'stops';
          }

          String text = '$number. Take bus $service at $board for $stopsTaken and alight at $alight';

          String result = "";

          for (int i = 0; i < services.length; i++) {
            String service = services[i];
            result += "$service: ${data.data[service]}";
            if (i != services.length - 1) {
              result += "\n";
            }
          }


          return ListTile(
            title: Text(text),
            subtitle: Text(result),
            onTap: () {super.setState(() {
              arriveData = getArrival(board, services);
            });},
          );
        }
        else {
          return Container(height: 50, width: 50, padding: const EdgeInsets.all(10), child: const CircularProgressIndicator());
        }
      },
    );
  }

}