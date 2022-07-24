import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigateus/screens/map/functions/bus_directions_service.dart';
import 'package:navigateus/screens/map/widgets/detailed_directions_row.dart';

class DetailedDirections extends StatelessWidget {
  final List<DirectionInstructions> instructions;
  final String startStop;
  final String destination;

  const DetailedDirections({
    Key? key,
    required this.instructions,
    required this.startStop,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    if (instructions.isEmpty) {
      return Container();
    }
    list.add(ListTile(title: Text('${list.length + 1}. Walk to $startStop bus stop')));

    for (DirectionInstructions instruction in instructions) {
      String services = '';
      for (int i = 0; i < instruction.bus.length; i++) {
        services += instruction.bus[i];
        if (instruction.bus.length > 1 && i != instruction.bus.length - 1) {
          services += '/';
        }
      }
      list.add(DetailedDirectionsRow(stops: '${instruction.stops}', service: services, number: list.length + 1, board: instruction.board, alight: instruction.alight));
    }

    list.add(ListTile(title: Text('${list.length + 1}. Walk to $destination')),);

    return Column(
      children: list,
    );
  }
}