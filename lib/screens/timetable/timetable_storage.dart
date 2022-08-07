import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/timetable_screen.dart';
import 'package:path_provider/path_provider.dart';

class TimetableStorage {
  Future<List<Module>> readTimetable() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();

      // Read the file
      final File file = File('${directory.path}/timetable.txt');
      String text = await file.readAsString();
      print('text: $text');
      List<Module> list = parseToList(text);
      return list;
    } catch (e) {
      // If encountering an error, return empty list
      return <Module>[];
    }
  }

  List<Module> parseToList(String contents) {
    List<Module> list = [];

    LineSplitter.split(contents).forEach((line) {
      print("line: $line");

      List<String> attributes = line.split(',');
      Module mod = Module(
          title: attributes[0],
          location: attributes[1],
          from: DateTime.parse(attributes[2]),
          to: DateTime.parse(attributes[3]),
          freq: attributes[4],
          recurrenceRule: attributes[5],
          background: Color(int.parse(attributes[6])));
      list.add(mod);
    });

    print(list);
    return list;
  }

  void writeTimetable(List<dynamic>? modules) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/timetable.txt');

    String save = "";
    for (Module mod in modules!) {
      save +=
          '${mod.title},${mod.location},${mod.from},${mod.to},${mod.freq},${mod.recurrenceRule},${mod.background.value}';
      save += '\n';
    }
    print('save: $save');

    await file.writeAsString(save);
  }
}
