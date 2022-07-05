import 'package:flutter/material.dart';
import 'package:navigateus/screens/calendar_widget.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Timetable"), centerTitle: true),
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => EventEditingPage()),
          ),
        ),
      ));
}
