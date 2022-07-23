import 'dart:async';
import 'dart:io';

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
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      print(parseToList(contents));

      return parseToList(contents);
    } catch (e) {
      // If encountering an error, return empty list
      return <Module>[];
    }
  }

  List<Module> parseToList(String contents) {
    List<Module> list = [];
    print(contents);
    return list;
  }

  Future<File> writeTimetable(List<Module> modules) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(modules.toString());
  }
}
