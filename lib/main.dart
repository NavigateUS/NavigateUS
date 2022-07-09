import 'package:flutter/material.dart';
import 'package:navigateus/screens/timetable/components/module_provider.dart';
import 'package:navigateus/screens/indoor_maps/indoor_maps.dart';
import 'package:navigateus/screens/map/map_screen.dart';
import 'package:navigateus/screens/timetable/timetable_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const NavigateUS());

class NavigateUS extends StatelessWidget {
  const NavigateUS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ModuleProvider(),
      child: const MaterialApp(
        title: 'NavigateUS',
        home: MapScreen(),
      ),
    );
  }
}
