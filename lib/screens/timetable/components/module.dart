import 'package:flutter/material.dart';

class Module {
  final String title;
  final String location;
  final DateTime from;
  final DateTime to;
  final String freq;
  final String recurrenceRule;
  final Color background;
  final bool isAllDay;

  const Module({
    required this.title,
    required this.location,
    required this.from,
    required this.to,
    required this.freq,
    required this.recurrenceRule,
    this.background = const Color(0xFFFC571D),
    this.isAllDay = false,
  });

  @override
  String toString() {
    if (location == "") {
      return title;
    }
    return "$title @ $location";
  }
}
