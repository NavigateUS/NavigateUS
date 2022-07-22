import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigateus/bus_data/bus_arrival.dart';

class DetailedDirectionsRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    List<String> services = service.split('/');

    return FutureBuilder<Response?>(
      future: getArrival(board, services),
      builder: (context, snapshot) {
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

          String message = data.data['message'];

          return ListTile(
            title: Text(text),
            subtitle: Text(message),
          );
        }
        else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}