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

  Map<Place, String> getPlaces() {
    Map<Place, String> places = {};
    Map<String, List<String>> search = {};

    for (int i = 0; i < appointments!.length; i++) {
      if (!search.keys.contains(getLocation(i))) {
        search[getLocation(i)] = [getSubject(i)];
      }
      else {
        search[getLocation(i)]?.add(getSubject(i));
      }
    }

    for (String placeName in search.keys) {
      String mods = '';
      for (int i = 0; i < search[placeName]!.length; i++) {
        String mod = search[placeName]![i];
        mods += mod;
        if (i != search[placeName]!.length - 1) {
          mods += ', ';
        }
      }
      places[nusLocations[placeName]!] = mods;
    }

    return places;
  }
}
