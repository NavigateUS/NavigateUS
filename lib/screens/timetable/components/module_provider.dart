import 'package:flutter/cupertino.dart';
import 'package:navigateus/screens/timetable/components/module.dart';

class ModuleProvider extends ChangeNotifier {
  final List<Module> _events = [];

  List<Module> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Module> get eventsOfSelectedDate => _events;

  void addEvent(Module event) {
    _events.add(event);

    notifyListeners();
  }

  void editEvent(Module newEvent, Module oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;

    notifyListeners();
  }

  void deleteEvent(Module event) {
    _events.remove(event);

    notifyListeners();
  }
}
