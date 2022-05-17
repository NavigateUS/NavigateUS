import 'package:flutter/material.dart';

Widget buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [const SizedBox(
        height: 125,
        child: DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.deepOrange,
          ),
          child: Text(
            'NavigateUS',
            style: TextStyle(fontSize: 24),),
        ),
      ),
        ListTile(
          title: const Text('Timetable'),
          onTap: () {
            // ToDo: Add timetabling function here
            // ...
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            // ToDo: Add settings here
            // ...
          },
        ),
      ],
    ),
  );
}