import 'package:flutter/material.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/components/data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'module_provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<ModuleProvider>(context).modules;
    return SfCalendar(
        view: CalendarView.week,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.schedule
        ],
        dataSource: DataSource(events),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.black12,
        onLongPress: (details) {
          final provider = Provider.of<ModuleProvider>(context, listen: false);
          provider.setDate(details.date!);
        });
  }
}
