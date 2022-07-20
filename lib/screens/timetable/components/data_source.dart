import 'package:flutter/material.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../places.dart';

class DataSource extends CalendarDataSource {
  DataSource(List<Module> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  @override
  String getSubject(int index) => appointments![index].title;

  @override
  String getLocation(int index) => appointments![index].location;

  @override
  String getRecurrenceRule(int index) => appointments![index].recurrenceRule;

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  List<Place> getPlaces() {
    List<Place> places = [];

    for (int i = 0; i < appointments!.length; i++) {
      places.add(locations.firstWhere(
          ((element) => element.toString().contains(getLocation(i)))));
      print(places);
    }
    return places;
  }
}
