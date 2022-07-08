import 'package:flutter/material.dart';
import 'package:navigateus/screens/timetable/components/calendar_widget.dart';
import 'package:navigateus/screens/timetable/components/data_source.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/components/module_provider.dart';
import 'package:navigateus/screens/timetable/event_editing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TimetableState();
}

class TimetableState extends State<TimetableScreen> {
  // final List<Color> _colorCollection = <Color>[];
  // final List<String> _colorNames = <String>[];
  // int _selectedColorIndex = 0;
  // int _selectedTimeZoneIndex = 0;
  // final List<String> _timeZoneCollection = <String>[];
  // late DataSource _events;
  // Module? _selectedAppointment;
  // late DateTime _startDate;
  // late TimeOfDay _startTime;
  // late DateTime _endDate;
  // late TimeOfDay _endTime;
  // bool _isAllDay = false;
  // String _subject = '';
  // String _notes = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ModuleProvider(),
      child: Scaffold(
          appBar: AppBar(title: const Text("Timetable"), centerTitle: true),
          body: SfCalendar(
              view: CalendarView.week,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.schedule
              ],
              dataSource: DataSource(getModules()),
              initialSelectedDate: DateTime.now(),
              cellBorderColor: Colors.black12,
              onLongPress: (details) {
                final provider =
                    Provider.of<ModuleProvider>(context, listen: false);
                provider.setDate(details.date!);
              }),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => const EventEditingPage()),
              ),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          )),
    );
  }

  List<Module> getModules() {
    List<Module> modules = <Module>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    modules.add(Module(
        title: "conference",
        location: "COM1",
        from: startTime,
        to: endTime,
        background: Colors.blue,
        recurrenceRule: "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO"));

    return modules;
  }

  // Void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
  //   if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
  //       calendarTapDetails.targetElement != CalendarElement.appointment) {
  //     return;
  //   }

  // setState(() {
  //   _selectedAppointment = null;
  //   _isAllDay = false;
  //   _selectedColorIndex = 0;
  //   _selectedTimeZoneIndex = 0;
  //   _subject = '';
  //   _notes = '';
  //   if (calendarTapDetails.appointments != null &&
  //       calendarTapDetails.appointments.length == 1) {
  //     final Module meetingDetails = calendarTapDetails.appointments[0];
  //     _startDate = meetingDetails.from;
  //     _endDate = meetingDetails.to;
  //     _selectedColorIndex =
  //         _colorCollection.indexOf(meetingDetails.background);
  //     _selectedAppointment = meetingDetails;
  //   } else {
  //     final DateTime date = calendarTapDetails.date;
  //     _startDate = st;
  //     _endDate = date.add(const Duration(hours: 1));
  //   }
  //   _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
  //   _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
  //   Navigator.push<Widget>(
  //     context,
  //     MaterialPageRoute(
  //         builder: (BuildContext context) => EventEditingPage()),
  //   );
  //   });
  // }

}
