import 'package:flutter/material.dart';
import 'package:navigateus/screens/timetable/components/calendar_widget.dart';
import 'package:navigateus/screens/timetable/event_editing.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TimetableState();
}

class TimetableState extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Timetable"), centerTitle: true),
        body: CalendarWidget(),
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
}
