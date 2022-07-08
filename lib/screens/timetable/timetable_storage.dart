import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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

  Future<String> readTimetable() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "error";
    }
  }

  Future<File> writeTimetable(List<Module> modules) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(modules.toString());
  }
}
