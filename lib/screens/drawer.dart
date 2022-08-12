import 'package:flutter/material.dart';
import 'package:navigateus/screens/bus_route/routes.dart';
import 'package:navigateus/screens/indoor_maps/indoor_maps.dart';
import 'package:navigateus/screens/setting.dart';

import 'package:navigateus/screens/timetable/timetable_screen.dart';

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(
          height: 125,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Text(
              'NavigateUS',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        ListTile(
          title: const Text('Indoor Maps'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const IndoorMap()));
          },
        ),
        ListTile(
          title: const Text('Timetable'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TimetableScreen()));
          },
        ),
        ListTile(
          title: const Text('Bus Routes'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BusRoutes()));
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingPage()));
          },
        ),
      ],
    ),
  );
}
