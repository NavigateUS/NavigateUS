import 'package:flutter/material.dart';

class Module {
  // module name, location,
  final String title;
  final String location;
  final DateTime from;
  final DateTime to;
  final String recurrenceRule;
  final Color background;

  const Module({
    required this.title,
    required this.location,
    required this.from,
    required this.to,
    required this.recurrenceRule,
    this.background = Colors.lightBlue,
  });

  @override
  String toString() {
    return "$title / $location / $recurrenceRule / $from / $to";
  }
}
