part of timetable;

class EventManagingPage extends StatefulWidget {
  const EventManagingPage({Key? key}) : super(key: key);

  @override
  EventManagingPageState createState() => EventManagingPageState();
}

class EventManagingPageState extends State<EventManagingPage> {
  @override
  Widget build(BuildContext context) {
    const title = 'Swipe to edit or delete module';

    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: moduleDataSource.appointments!.length,
          itemBuilder: (context, index) {
            _selectedAppointment = moduleDataSource.appointments?[index];
            String modTitle = _selectedAppointment.toString();
            return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  // Edit item
                  if (direction == DismissDirection.startToEnd) {
                    setState(() {
                      _startDate = _selectedAppointment!.from;
                      _endDate = _selectedAppointment!.to;
                      _selectedColorIndex = _colorCollection
                          .indexOf(_selectedAppointment!.background);
                      _title = _selectedAppointment!.title == '(No title)'
                          ? ''
                          : _selectedAppointment!.title;
                      _location = _selectedAppointment!.location;

                      _startTime = TimeOfDay(
                          hour: _startDate.hour, minute: _startDate.minute);
                      _endTime = TimeOfDay(
                          hour: _endDate.hour, minute: _endDate.minute);
                      Navigator.push<Widget>(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const EventEditingPage()),
                      );
                      _selectedAppointment = null;
                    });
                  } else {
                    // Remove the item from the data source.
                    setState(() {
                      moduleDataSource.appointments!.removeAt(moduleDataSource
                          .appointments!
                          .indexOf(_selectedAppointment));
                      moduleDataSource.notifyListeners(
                          CalendarDataSourceAction.remove,
                          <Module>[_selectedAppointment!]);
                      _selectedAppointment = null;
                    });
                  }
                },

                // Show a red background as the item is swiped away.
                background: Container(
                    color: Colors.green,
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.white),
                        Text('Edit Module',
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(Icons.delete_outline, color: Colors.white),
                        Text('Remove Module From Calendar',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: ListTile(
                    title: Text(modTitle),
                  ),
                ));
          },
        ));
  }
}
