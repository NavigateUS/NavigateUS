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
List<Color> _colorCollection = <Color>[
  const Color(0xfff07878),
  const Color(0xfff89154),
  const Color(0xffffcc65),
  const Color(0xff9bcb9a),
  const Color(0xff6acccd),
  const Color(0xff6699cc),
  const Color(0xffca9acc),
  const Color(0xffd17b51),
];
List<String> _colorNames = <String>[
  'Light Coral',
  'Faded Orange',
  'Light Mustard',
  'Frog Green',
  'Downy',
  'Blue Koi',
  'Pastel Violet',
  'Raw Sienna',
];
int _selectedColorIndex = 0;
List<Module> modules = <Module>[];
DataSource moduleDataSource = DataSource(modules);

Module? _selectedAppointment;

// Module Details Editing
String _title = '';
String _location = '';
late DateTime _startDate;
late DateTime _endDate;
late TimeOfDay _startTime;
late TimeOfDay _endTime;
String selectedFreq = "Weekly";
String selectedDay = DateFormat('EEEE').format(_startDate);

class TimetableState extends State<TimetableScreen> {
  TimetableState();

  late List<String> eventNameCollection;

  @override
  void initState() {
    super.initState();
    storage.readTimetable().then((value) {
      setState(() {
        modules = value;
        moduleDataSource = DataSource(modules);
      });
    });

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

      final DateTime date = calendarTapDetails.date!;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      selectedDay = DateFormat('EEEE').format(_startDate);

      Navigator.push<Widget>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const EventEditingPage()),
      );
    });
  }
}
