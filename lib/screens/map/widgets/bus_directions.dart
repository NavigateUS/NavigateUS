import 'package:flutter/material.dart';
import 'package:navigateus/screens/map/functions/bus_directions_service.dart';
import 'package:navigateus/screens/map/widgets/bus_tile.dart';

class BusDirections extends StatelessWidget {
  final List<DirectionInstructions> instructions;

  const BusDirections({
    Key? key,
    required this.instructions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (DirectionInstructions instruction in instructions) {
      String services = '';
      for (int i = 0; i < instruction.bus.length; i++) {
        services += instruction.bus[i];
        if (instruction.bus.length > 1 && i != instruction.bus.length - 1) {
          services += '/';
        }
      }
      list.add(BusTile(stops: '${instruction.stops}', service: services));
      list.add(
        const Icon(Icons.keyboard_arrow_right_sharp),
      );
    }
    return Row(
      children: list,
    );
  }

  int getLength() {
    List<Widget> list = [];
    for (DirectionInstructions instruction in instructions) {
      String services = '';
      for (int i = 0; i < instruction.bus.length; i++) {
        services += instruction.bus[i];
        if (instruction.bus.length > 1 && i != instruction.bus.length - 1) {
          services += '/';
        }
      }
      list.add(BusTile(stops: '${instruction.stops}', service: services));
    }
    return list.length;
  }
}
