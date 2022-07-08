import 'package:flutter/cupertino.dart';
import 'package:navigateus/screens/timetable/components/module.dart';

class ModuleProvider extends ChangeNotifier {
  final List<Module> _mods = [];

  List<Module> get modules => _mods;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Module> get eventsOfSelectedDate => _mods;

  void addModule(Module event) {
    _mods.add(event);

    notifyListeners();
  }

  void editModule(Module newEvent, Module oldEvent) {
    final index = _mods.indexOf(oldEvent);
    _mods[index] = newEvent;

    notifyListeners();
  }

  void deleteModule(Module module) {
    _mods.remove(module);

    notifyListeners();
  }
}
