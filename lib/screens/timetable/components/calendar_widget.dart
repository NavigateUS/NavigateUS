import 'package:flutter/material.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/components/module_data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'module_provider.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key? key}) : super(key: key);

  final CalendarDataSource dataSource = DataSource(<Module>[]);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<ModuleProvider>(context).events;

    return SfCalendar(
        view: CalendarView.schedule,
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
          final provider = Provider.of<ModuleProvider>(context, listen: true);
          provider.setDate(details.date!);
        });
  }
}
