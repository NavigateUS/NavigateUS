import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailedDirectionsRow extends StatelessWidget {
  final String stops;
  final String service;
  final int number;
  //final String waitTime;

  const DetailedDirectionsRow({
    Key? key,
    required this.stops,
    required this.service,
    required this.number
    //required this.waitTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String stopsTaken = stops;
    stopsTaken += ' ';
    if (int.parse(stops) == 1) {
      stopsTaken += 'stop';
    }
    else{
      stopsTaken += 'stops';
    }

    String text = '$number. Take bus $service for $stopsTaken';

    return ListTile(
      title: Text(text),
      subtitle: Text('Wait time: 3 mins'),  //ToDo: get wait times
    );
  }
}