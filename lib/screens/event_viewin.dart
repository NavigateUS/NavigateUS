import 'package:flutter/material.dart';
import 'package:navigateus/screens/event.dart';
import 'package:navigateus/screens/event_editing.dart';
import 'package:navigateus/screens/event_provider.dart';
import 'package:navigateus/screens/utils.dart';
import 'package:provider/provider.dart';

class EventViewingPage extends StatelessWidget {
  final Event? event;

  const EventViewingPage({Key? key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: CloseButton(),
            actions: buildViewingActions(context, event)),
        body: ListView(
          padding: EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            SizedBox(
              height: 32,
            ),
            Text(
              event.title,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              event.description,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ));
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {}

  List<Widget> buildViewingActions(BuildContext context, Event event) => [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(event: event),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);
            provider.deleteEvent(event);
          },
        )
      ];
}
