import 'package:flutter/material.dart';
import 'package:navigateus/screens/event_data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
        view: CalendarView.month,
        dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
        onLongPress: (details) {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.setDate(details.date!);
        });
  }
}
