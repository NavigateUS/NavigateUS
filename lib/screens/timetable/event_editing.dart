import 'package:flutter/material.dart';
import 'package:navigateus/places.dart';
import 'package:navigateus/screens/timetable/components/module.dart';
import 'package:navigateus/screens/timetable/components/module_provider.dart';
import 'package:navigateus/screens/timetable/components/utils.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class EventEditingPage extends StatefulWidget {
  final Module? event;

  const EventEditingPage({Key? key, this.event}) : super(key: key);

  @override
  EventEditingPageState createState() => EventEditingPageState();
}

class EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  late TimeOfDay fromTime = TimeOfDay.now();
  late TimeOfDay toTime = TimeOfDay.now();
  bool asTabs = false;
  String? selectedValueSingleDialog;
  String? selectedValueSingleDoneButtonDialog;
  String? selectedValueSingleMenu;
  String? selectedValueSingleDialogCustomKeyboard;
  String? selectedValueSingleDialogOverflow;
  String? selectedValueSingleDialogEditableItems;
  String? selectedValueSingleMenuEditableItems;
  String? selectedValueSingleDialogDarkMode;
  String? selectedValueSingleDialogEllipsis;
  String? selectedValueSingleDialogRightToLeft;
  String? selectedValueUpdateFromOutsideThePlugin;
  dynamic selectedValueSingleDialogPaged;
  dynamic selectedValueSingleDialogPagedFuture;
  dynamic selectedValueSingleDialogFuture;
  List<int> selectedItemsMultiDialog = [];
  List<int> selectedItemsMultiCustomDisplayDialog = [];
  List<int> selectedItemsMultiSelect3Dialog = [];
  List<int> selectedItemsMultiMenu = [];
  List<int> selectedItemsMultiMenuSelectAllNone = [];
  List<int> selectedItemsMultiDialogSelectAllNoneWoClear = [];
  List<int> editableSelectedItems = [];
  List<DropdownMenuItem> items = Place.getDropdownList();

  String inputString = "";
  TextFormField? input;
  List<int> selectedItemsMultiSelect3Menu = [];
  List<int> selectedItemsMultiDialogWithCountAndWrap = [];
  List<int> selectedItemsMultiDialogPaged = [];
  List<Map<String, dynamic>> selectedItemsMultiMenuPagedFuture = [];
  List<Map<String, dynamic>> selectedItemsMultiDialogPagedFuture = [];

  Function? openDialog;

  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);

  bool noResult = false;

  String widgetSearchString = "";

  TextEditingController widgetSearchController = TextEditingController();

  final String loremIpssum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  @override
  initState() {
    if (widget.event == null) {
      // fromDate = DateTime.now();
      // toDate = DateTime.now().add(const Duration(hours: 2));
      fromTime = TimeOfDay.now();
      toTime = TimeOfDay.now();
    } else {
      final event = widget.event!;
      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
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
        saveForm;
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
      onFieldSubmitted: (_) => saveForm(),
      validator: (title) =>
          title != null && title.isEmpty ? 'Module cannot be empty' : null,
      controller: titleController,
    );
  }

  Widget buildLocation() {
    return SearchChoices.single(
      items: items,
      value: selectedValueSingleDialog,
      hint: "Select location",
      searchHint: "Select location",
      onChanged: (value) {
        setState(() {
          selectedValueSingleDialog = value;
        });
      },
      isExpanded: true,
    );
  }

  String dropdownvalue = "Monday";
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
          value: dropdownvalue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: weekday.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
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

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Module(
        title: titleController.text,
        location: 'location',
        from: fromDate,
        to: toDate,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<ModuleProvider>(context, listen: false);

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
