import 'package:flutter/material.dart';
import 'package:navigateus/screens/event.dart';
import 'package:navigateus/screens/event_provider.dart';
import 'package:navigateus/screens/utils.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({Key? key, this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventEditingPageState();
}

class EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              buildDateTimePickers(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() {
    return [
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: saveForm,
        icon: Icon(Icons.done),
        label: Text('Save'),
      ),
    ];
  }

  Widget buildTitle() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Module',
      ),
      onFieldSubmitted: (_) => saveForm(),
      validator: (title) =>
          title != null && title.isEmpty ? 'Module cannot be empty' : null,
      controller: titleController,
    );
  }

  buildDateTimePickers() {
    return Column(
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  buildFrom() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropDownField(
            text: Utils.toDate(fromDate),
            onClicked: () {
              pickFromDateTime(pickDate: true);
            },
          ),
        ),
        Expanded(
          child: buildDropDownField(
            text: Utils.toTime(fromDate),
            onClicked: () {
              pickFromDateTime(pickDate: false);
            },
          ),
        )
      ],
    );
  }

  buildTo() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropDownField(
            text: Utils.toDate(toDate),
            onClicked: () {
              pickToDateTime(pickDate: true);
            },
          ),
        ),
        Expanded(
          child: buildDropDownField(
            text: Utils.toTime(toDate),
            onClicked: () {
              pickToDateTime(pickDate: false);
            },
          ),
        )
      ],
    );
  }

  buildDropDownField({required String text, required VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_drop_down),
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );

    if (date == null) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
      }

      Navigator.of(context).pop;
    }
  }
}
