library timetable;

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:navigateus/places.dart';
import 'package:navigateus/screens/timetable/components/data_source.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/timetable_storage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:search_choices/search_choices.dart';

part 'event_editing.dart';
part 'color_picker.dart';
part 'event_managing.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  TimetableState createState() => TimetableState();
}

TimetableStorage storage = TimetableStorage();

// initialization
List<DropdownMenuItem> places = Place.getDropdownList();
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedColorIndex = 0;
List<Module> modules = <Module>[];
DataSource moduleDataSource = DataSource(modules);

Module? _selectedAppointment;

// Module Details Editing
String _title = '';
String _location = ' ';
late DateTime _startDate;
late DateTime _endDate;
late TimeOfDay _startTime;
late TimeOfDay _endTime;
String selectedDay = "Wednesday";

class TimetableState extends State<TimetableScreen> {
  TimetableState();

  late List<String> eventNameCollection;
  late List<Module> appointments;

  @override
  void initState() {
    super.initState();
    storage.readTimetable().then((value) {
      setState(() {
        modules = value;
        print("modules: $modules");
        appointments = modules;
        print("appointments: $appointments");
        moduleDataSource = DataSource(appointments);
      });
    });
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFFFF00FF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Magenta');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    //events
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _title = '';
    _location = '';
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(hours: 1));
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timetable"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          SfCalendar(
            view: CalendarView.week,
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
            ],
            dataSource: moduleDataSource,
            initialDisplayDate: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 0, 0, 0),
            cellBorderColor: Colors.black12,
            onTap: onCalendarTapped,
            timeSlotViewSettings: const TimeSlotViewSettings(
                minimumAppointmentDuration: Duration(minutes: 60)),
          ),
          Positioned(
            bottom: 30,
            right: 15,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: Colors.deepOrange,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => const EventEditingPage()),
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: Colors.deepOrange,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => const EventManagingPage()),
                    ),
                  ),
                  child: const Icon(Icons.calendar_month, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
      // if (calendarTapDetails.appointments != null &&
      //     calendarTapDetails.appointments!.length == 1) {
      //   final Module moduleDetails = calendarTapDetails.appointments![0];
      //   _startDate = moduleDetails.from;
      //   _endDate = moduleDetails.to;
      //   _selectedColorIndex =
      //       _colorCollection.indexOf(moduleDetails.background);
      //   _title = moduleDetails.title == '(No title)' ? '' : moduleDetails.title;
      //   _location = moduleDetails.location;
      //   _selectedAppointment = moduleDetails;
      // } else {
      final DateTime date = calendarTapDetails.date!;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      selectedDay = DateFormat('EEEE').format(_startDate);
      // }
      // _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      // _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
      Navigator.push<Widget>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const EventEditingPage()),
      );
    });
  }
}
