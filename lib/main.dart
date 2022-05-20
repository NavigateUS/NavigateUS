import 'package:flutter/material.dart';
import 'package:navigateus/screens/map_screen.dart';

void main() => runApp(const NavigateUS());

class NavigateUS extends StatelessWidget {
  const NavigateUS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'NavigateUS',
      home: MapScreen(),
    );
  }
}
