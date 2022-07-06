import 'package:flutter/material.dart';

class Module {
  // module name, location,
  final String title;
  final String location;
  final DateTime from;
  final DateTime to;
  final Color background;

  const Module({
    required this.title,
    required this.location,
    required this.from,
    required this.to,
    this.background = Colors.lightGreen,
  });
}
