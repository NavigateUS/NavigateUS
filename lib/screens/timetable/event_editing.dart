import 'package:flutter/material.dart';
import 'package:navigateus/places.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/components/module_provider.dart';
import 'package:navigateus/screens/timetable/components/utils.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class EventEditingPage extends StatefulWidget {
  final Module? module;

  const EventEditingPage({Key? key, this.module}) : super(key: key);

  @override
  EventEditingPageState createState() => EventEditingPageState();
}

class EventEditingPageState extends State<EventEditingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime startDate;
  late DateTime endDate;
  late TimeOfDay fromTime;
  late TimeOfDay toTime;
  String? selectedLocation;
  List<DropdownMenuItem> items = Place.getDropdownList();
  String selectedDay = "Monday";

  TextEditingController widgetSearchController = TextEditingController();

  @override
  initState() {
    if (widget.module == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours: 2));
      fromTime = TimeOfDay.fromDateTime(startDate);
      toTime = TimeOfDay.fromDateTime(endDate);
    } else {
      final event = widget.module!;
      titleController.text = event.title;
      startDate = event.from;
      endDate = event.to;
    }
    super.initState();
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
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              buildLocation(),
              buildWeekday(),
              buildFromTimePicker(),
              buildToTimePicker(),
              buildEditingActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditingActions() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        saveForm();
      },
      icon: const Icon(Icons.done),
      label: const Text('Save'),
    );
  }

  Widget buildTitle() {
    return TextFormField(
      style: const TextStyle(fontSize: 24),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Module',
      ),
      // onFieldSubmitted: (_) => saveForm(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (title) =>
          title != null && title.isEmpty ? 'Module cannot be empty' : null,
      controller: titleController,
    );
  }

  Widget buildLocation() {
    return SearchChoices.single(
      items: items,
      value: selectedLocation,
      hint: "Select location",
      searchHint: "Select location",
      validator: (value) =>
          value != null && value.isEmpty ? 'Location cannot be empty' : null,
      onChanged: (value) {
        setState(() {
          selectedLocation = value;
        });
      },
      isExpanded: true,
    );
  }

  var weekday = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  Widget buildWeekday() {
    return Row(
      children: [
        const Expanded(
            flex: 1, child: Text("Weekday", style: TextStyle(fontSize: 20))),
        DropdownButton(
          value: selectedDay,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: weekday.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedDay = newValue!;
            });
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    );
  }

  Widget buildFromTimePicker() {
    return Row(
      children: [
        const Expanded(
            flex: 2, child: Text("From", style: TextStyle(fontSize: 20))),
        Expanded(
            flex: 2,
            child: Text(
              fromTime.format(context),
              style: const TextStyle(fontSize: 20),
            )),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            child: const Text("Select"),
            onPressed: () {
              setFromTime(context);
            },
          ),
        )
      ],
    );
  }

  Widget buildToTimePicker() {
    return Row(
      children: [
        const Expanded(
            flex: 2, child: Text("To", style: TextStyle(fontSize: 20))),
        Expanded(
            flex: 2,
            child: Text(
              toTime.format(context),
              style: const TextStyle(fontSize: 20),
            )),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            child: const Text("Select"),
            onPressed: () {
              setToTime(context);
            },
          ),
        )
      ],
    );
  }

  setFromTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: fromTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != TimeOfDay.now()) {
      setState(() {
        fromTime = timeOfDay;
      });
    }
  }

  setToTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != TimeOfDay.now()) {
      setState(() {
        toTime = timeOfDay;
      });
    }
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
            text: Utils.toDate(startDate),
            onClicked: () {
              pickFromDateTime(pickDate: true);
            },
          ),
        ),
        Expanded(
          child: buildDropDownField(
            text: Utils.toTime(startDate),
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
            text: Utils.toDate(endDate),
            onClicked: () {
              pickToDateTime(pickDate: true);
            },
          ),
        ),
        Expanded(
          child: buildDropDownField(
            text: Utils.toTime(endDate),
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
    final date = await pickDateTime(startDate, pickDate: pickDate);

    if (date == null) return;

    if (date.isAfter(endDate)) {
      endDate = DateTime(
          date.year, date.month, date.day, endDate.hour, endDate.minute);
    }
    setState(() => startDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      endDate,
      pickDate: pickDate,
      firstDate: pickDate ? startDate : null,
    );

    if (date == null) return;

    setState(() => endDate = date);
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
        firstDate: firstDate ?? DateTime(2020, 8),
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

  String toDay(String day) {
    return day.substring(0, 2).toUpperCase();
  }

  Future saveForm() async {
    final isValid =
        _formKey.currentState!.validate() && selectedLocation != null;

    String day = toDay(selectedDay);
    if (isValid) {
      final module = Module(
          title: titleController.text,
          location: selectedLocation!,
          weekday: selectedDay,
          from: startDate,
          to: endDate,
          recurrenceRule: "FREQ=WEEKLY;INTERVAL=1;BYDAY=$day;COUNT=13");

      final isEditing = widget.module != null;
      final provider = Provider.of<ModuleProvider>(context, listen: false);
      if (isEditing) {
        provider.editModule(module, widget.module!);
        Navigator.pop(context);
      } else {
        provider.addModule(module);
      }
      Navigator.pop(context);
    }
  }
}
