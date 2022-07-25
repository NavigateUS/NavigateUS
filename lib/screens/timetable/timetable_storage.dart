import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:path_provider/path_provider.dart';

class TimetableStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/timetable.txt');
  }

  Future<List<Module>> readTimetable() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();

      // Read the file
      final File file = File('${directory.path}/timetable.txt');

      String text = await file.readAsString();

      print('text: $text');

      return parseToList(text);
    } catch (e) {
      // If encountering an error, return empty list
      return <Module>[];
    }
  }

  List<Module> parseToList(String contents) {
    List<Module> list = [];
    print(contents);

    LineSplitter.split(contents).forEach((line) {
      print(line);

      List<String> attributes = line.split(',');
      Module mod = Module(
          title: attributes[0],
          location: attributes[1],
          from: DateTime.parse(attributes[2]),
          to: DateTime.parse(attributes[3]),
          recurrenceRule: attributes[4]);
      list.add(mod);
    });

    return list;
  }

  void writeTimetable(List<Module> modules) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/timetable.txt');

    String save = "";
    for (Module mod in modules) {
      save +=
          '${mod.title},${mod.location},${mod.from},${mod.to},${mod.recurrenceRule}';
      save += '\n';
    }
    print('save: $save');

    await file.writeAsString(save);
  }
}
