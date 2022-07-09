library timetable;

import 'package:flutter/material.dart';
import 'package:navigateus/places.dart';
import 'package:navigateus/screens/timetable/components/data_source.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/components/module_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';

part 'event_editing.dart';
part 'color_picker.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TimetableState();
}

// initialization
late DataSource _moduleDataSource;
Module? _selectedAppointment;
List<Module> modules = <Module>[];

// Module Details Editing
String _title = '';
String _location = '';
String selectedDay = "Wednesday";
DateTime _startDate = DateTime.now();
DateTime _endDate = DateTime.now().add(const Duration(hours: 2));
late TimeOfDay _startTime;
late TimeOfDay _endTime;

List<DropdownMenuItem> places = Place.getDropdownList();
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedColorIndex = 0;

class TimetableState extends State<TimetableScreen> {
  late List<String> eventNameCollection;
  late List<Module> appointments;

  @override
  void initState() {
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFFFF00FF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Magenta');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');
    _title = '';
    _location = '';
    selectedDay = "Wednesday";
    _moduleDataSource = DataSource(modules);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Timetable"), centerTitle: true),
        body: SfCalendar(
            view: CalendarView.week,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.schedule
            ],
            dataSource: _moduleDataSource,
            initialSelectedDate: DateTime.now(),
            cellBorderColor: Colors.black12,
            onTap: (details) {
              onCalendarTapped(details);
              // final provider =
              //     Provider.of<ModuleProvider>(context, listen: false);
              // provider.setDate(details.date!);
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const EventEditingPage()),
            ),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ));
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _selectedColorIndex = 0;
      _title = '';
      _location = '';

      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.appointments!.length == 1) {
        final Module moduleDetails = calendarTapDetails.appointments![0];
        _startDate = moduleDetails.from;
        _endDate = moduleDetails.to;
        _selectedColorIndex =
            _colorCollection.indexOf(moduleDetails.background);
        _title = moduleDetails.title == '(No title)' ? '' : moduleDetails.title;
        _location = moduleDetails.location;
        _selectedAppointment = moduleDetails;
      } else {
        final DateTime date = calendarTapDetails.date!;
        _startDate = date;
        _endDate = date.add(const Duration(hours: 1));
      }
      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
      Navigator.push<Widget>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EventEditingPage()),
      );
    });
  }
}
