part of timetable;

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({Key? key}) : super(key: key);

  @override
  EventEditingPageState createState() => EventEditingPageState();
}

class EventEditingPageState extends State<EventEditingPage> {
  @override
  void initState() {
    super.initState();
    selectedDay = DateFormat('EEEE').format(_startDate);
  }

  Widget _getAppointmentEditor(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            buildTitle(),
            buildLocation(),
            buildFromTimePicker(),
            buildToTimePicker(),
            buildWeekday(),
            buildColorPicker(context)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                setState(() {
                  _selectedAppointment = null;
                  _title = "";
                  _location = "";
                });
                Navigator.pop(context);
                setState(() {});
              },
            ),
            actions: <Widget>[
              IconButton(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                icon: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                onPressed: save,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Stack(
              children: <Widget>[_getAppointmentEditor(context)],
            ),
          ),
    ));
  }

  String getTile() {
    return _title.isEmpty ? 'New Module' : 'Event details';
  }

  void save() {
    String day = selectedDay.substring(0, 2).toUpperCase();

    final List<Module> mods = <Module>[];
    if (_selectedAppointment != null) {
      if (moduleDataSource.appointments!.contains(_selectedAppointment)) {
        moduleDataSource.appointments!.remove(_selectedAppointment);
      }
      else {
        throw Future.error('selected appointment not found');
      }
      moduleDataSource.notifyListeners(
          CalendarDataSourceAction.remove, <Module>[_selectedAppointment!]);
    }

    mods.add(Module(
      from: _startDate,
      to: _endDate,
      background: _colorCollection[_selectedColorIndex],
      location: _location,
      title: _title == '' ? '(No title)' : _title,
      recurrenceRule: "FREQ=WEEKLY;INTERVAL=1;BYDAY=$day;COUNT=13",
    ));

    moduleDataSource.appointments!.add(mods[0]);

    moduleDataSource.notifyListeners(CalendarDataSourceAction.add, mods);

    setState(() {
      _selectedAppointment = null;
      _title = "";
      _location = "";
    });

    storage.writeTimetable(moduleDataSource.appointments);

    setState(() {});

    moduleDataSource.appointments!.sort((a, b) => a.title.compareTo(b.title));

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
      controller: TextEditingController(text: _title),
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
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Expanded(child: Text("From", style: TextStyle(fontSize: 20))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                GestureDetector(
                    child: Text(
                      DateFormat('EEE, MMM dd yyyy').format(_startDate),
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 18),
                    ),
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (date != null && date != _startDate) {
                        setState(() {
                          final Duration difference =
                              _endDate.difference(_startDate);
                          _startDate = DateTime(date.year, date.month, date.day,
                              _startTime.hour, _startTime.minute, 0);
                          _endDate = _startDate.add(difference);
                          _endTime = TimeOfDay(
                              hour: _endDate.hour, minute: _endDate.minute);
                          selectedDay = DateFormat('EEEE').format(_startDate);
                        });
                      }
                    }),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
          Expanded(
              child: GestureDetector(
                  child: Text(
                    DateFormat('hh:mm a').format(_startDate),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
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
                            _startDate.year,
                            _startDate.month,
                            _startDate.day,
                            _startTime.hour,
                            _startTime.minute,
                            0);
                        _endDate = _startDate.add(difference);
                        _endTime = TimeOfDay(
                            hour: _endDate.hour, minute: _endDate.minute);
                      });
                    }
                  })),
          const Icon(Icons.keyboard_arrow_down),
        ]));
  }

  Widget buildToTimePicker() {
    return SizedBox(
      height: 40,
      child: Row(children: [
        const Expanded(child: Text("To", style: TextStyle(fontSize: 20))),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              GestureDetector(
                  child: Text(
                    DateFormat('EEE, MMM dd yyyy').format(_endDate),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (date != null && date != _endDate) {
                      setState(() {
                        final Duration difference =
                            _endDate.difference(_startDate);
                        _endDate = DateTime(date.year, date.month, date.day,
                            _endTime.hour, _endTime.minute, 0);
                        if (_endDate.isBefore(_startDate)) {
                          _startDate = _endDate.subtract(difference);
                          _startTime = TimeOfDay(
                              hour: _startDate.hour, minute: _startDate.minute);
                        }
                        if (_endDate.day != _startDate.day) {
                          _startDate = DateTime(
                              _endDate.year,
                              _endDate.month,
                              _endDate.day,
                              _startTime.hour,
                              _startTime.minute,
                              0);
                        }
                      });
                    }
                  }),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        Expanded(
            child: GestureDetector(
                child: Text(
                  DateFormat('hh:mm a').format(_endDate),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 18),
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
                      _endDate = DateTime(_endDate.year, _endDate.month,
                          _endDate.day, _endTime.hour, _endTime.minute, 0);
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
    'Saturday',
    'Sunday'
  ];

  Widget buildWeekday() {
    return Row(
      children: [
        const Expanded(
            flex: 1, child: Text("Weekday", style: TextStyle(fontSize: 20))),
        Text(selectedDay, style: const TextStyle(fontSize: 20)),
        // DropdownButton(
        //   value: DateFormat('EEEE').format(_startDate),
        //   icon: const Icon(Icons.keyboard_arrow_down),
        //   items: weekday.map((String items) {
        //     return DropdownMenuItem(
        //       value: items,
        //       child: Text(items),
        //     );
        //   }).toList(),
        //   onChanged: (String? newValue) {
        //     setState(() {
        //       selectedDay = newValue!;
        //     });
        //   },
        //   style: const TextStyle(fontSize: 20, color: Colors.black),
        // ),
      ],
    );
  }

  ListTile buildColorPicker(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      leading: Icon(Icons.lens, color: _colorCollection[_selectedColorIndex]),
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
    );
  }
}
