import 'package:flutter/material.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/components/utils.dart';
import 'package:navigateus/screens/timetable/event_editing.dart';
import 'package:navigateus/screens/timetable/components/module_provider.dart';
import 'package:provider/provider.dart';

class EventViewingPage extends StatelessWidget {
  final Module event;

  const EventViewingPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: const CloseButton(),
            actions: buildViewingActions(context, event)),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            const SizedBox(
              height: 32,
            ),
            Text(
              event.title,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              event.location,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ));
  }

  Widget buildDateTime(Module event) {
    return Column(
      children: const [],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Row(
      children: [
        Text(
          title,
        ),
        Text(
          Utils.toDate(date),
        ),
      ],
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Module event) => [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(event: event),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final provider =
                Provider.of<ModuleProvider>(context, listen: false);
            provider.deleteEvent(event);
          },
        )
      ];
}
