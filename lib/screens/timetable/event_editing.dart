part of timetable;

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({Key? key}) : super(key: key);

  // final Module? module;

  // const EventEditingPage({Key? key, this.module}) : super(key: key);

  @override
  EventEditingPageState createState() => EventEditingPageState();
}

class EventEditingPageState extends State<EventEditingPage> {
  final titleController = TextEditingController();

  Widget _getAppointmentEditor(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // padding: const EdgeInsets.all(0),
          children: <Widget>[
            buildTitle(),
            buildLocation(),
            buildWeekday(),
            buildFromTimePicker(),
            buildToTimePicker(),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens,
                  color: _colorCollection[_selectedColorIndex]),
              title: Text(
                _colorNames[_selectedColorIndex],
              ),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _ColorPicker();
                  },
                ).then((dynamic value) => setState(() {}));
              },
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(getTile()),
              backgroundColor: _colorCollection[_selectedColorIndex],
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      save();
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
            floatingActionButton: _selectedAppointment == null
                ? const Text('')
                : FloatingActionButton(
                    onPressed: () {
                      if (_selectedAppointment != null) {
                        _moduleDataSource.appointments!.removeAt(
                            _moduleDataSource.appointments!
                                .indexOf(_selectedAppointment));
                        _moduleDataSource.notifyListeners(
                            CalendarDataSourceAction.remove,
                            <Module>[_selectedAppointment!]);
                        _selectedAppointment = null;
                        Navigator.pop(context);
                      }
                    },
                    backgroundColor: Colors.red,
                    child:
                        const Icon(Icons.delete_outline, color: Colors.white),
                  )));
  }

  String getTile() {
    return _title.isEmpty ? 'New Module' : 'Event details';
  }

  void save() {
    String day = selectedDay.substring(0, 2).toUpperCase();

    if (_selectedAppointment != null) {
      _moduleDataSource.appointments!.removeAt(
          _moduleDataSource.appointments!.indexOf(_selectedAppointment));
      _moduleDataSource.notifyListeners(
          CalendarDataSourceAction.remove, <Module>[_selectedAppointment!]);
    }
    modules.add(Module(
      from: _startDate,
      to: _endDate,
      background: _colorCollection[_selectedColorIndex],
      location: _location,
      title: _title == '' ? '(No title)' : _title,
      recurrenceRule: "FREQ=WEEKLY;INTERVAL=1;BYDAY=$day",
    ));

    _moduleDataSource.notifyListeners(CalendarDataSourceAction.add, modules);
    _selectedAppointment = null;

    Navigator.pop(context);
  }

  Widget buildTitle() {
    return TextFormField(
      style: const TextStyle(fontSize: 24),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Module',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: titleController,
      onChanged: (change) {
        _title = change;
      },
    );
  }

  Widget buildLocation() {
    return SearchChoices.single(
      items: places,
      value: _location,
      hint: "Select location",
      searchHint: "Select location",
      validator: (value) =>
          value != null && value.isEmpty ? 'Location cannot be empty' : null,
      onChanged: (value) {
        setState(() {
          _location = value;
        });
      },
      isExpanded: true,
    );
  }

  Widget buildFromTimePicker() {
    return SizedBox(
        height: 40,
        child: Row(children: [
          const Expanded(
              flex: 1, child: Text("From", style: TextStyle(fontSize: 20))),
          Expanded(
            flex: 2,
            child: GestureDetector(
                child: Text(
                  DateFormat('hh:mm a').format(_startDate),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                          hour: _startTime.hour, minute: _startTime.minute));

                  if (time != null && time != _startTime) {
                    setState(() {
                      _startTime = time;
                      final Duration difference =
                          _endDate.difference(_startDate);
                      _startDate = DateTime(
                          2022, 1, 1, _startTime.hour, _startTime.minute, 0);
                      _endDate = _startDate.add(difference);
                      _endTime = TimeOfDay(
                          hour: _endDate.hour, minute: _endDate.minute);
                    });
                  }
                }),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ]));
  }

  Widget buildToTimePicker() {
    return SizedBox(
      height: 40,
      child: Row(children: [
        const Expanded(
            flex: 1, child: Text("To", style: TextStyle(fontSize: 20))),
        Expanded(
            flex: 2,
            child: GestureDetector(
                child: Text(
                  DateFormat('hh:mm a').format(_endDate),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                          hour: _endTime.hour, minute: _endTime.minute));

                  if (time != null && time != _endTime) {
                    setState(() {
                      _endTime = time;
                      final Duration difference =
                          _endDate.difference(_startDate);
                      _endDate = DateTime(
                          2022, 1, 1, _endTime.hour, _endTime.minute, 0);
                      if (_endDate.isBefore(_startDate)) {
                        _startDate = _endDate.subtract(difference);
                        _startTime = TimeOfDay(
                            hour: _startDate.hour, minute: _startDate.minute);
                      }
                    });
                  }
                })),
        const Icon(Icons.keyboard_arrow_down),
      ]),
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
}
