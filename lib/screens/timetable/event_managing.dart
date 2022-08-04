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
          backgroundColor: Colors.deepOrange,
        ),
        body: ListView.builder(
          itemCount: moduleDataSource.appointments!.length,
          itemBuilder: (context, index) {
            Module tempAppointment = moduleDataSource.appointments?[index];
            // _selectedAppointment = moduleDataSource.appointments?[index];
            String modTitle = tempAppointment.toString();
            return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  // Edit item
                  if (direction == DismissDirection.startToEnd) {
                    setState(() {
                      _selectedAppointment =
                          tempAppointment;

                      _startDate = tempAppointment!.from;
                      _endDate = tempAppointment!.to;
                      _selectedColorIndex = _colorCollection
                          .indexOf(tempAppointment!.background);
                      _title = tempAppointment!.title == '(No title)'
                          ? ''
                          : tempAppointment!.title;
                      _location = tempAppointment!.location;

                      _startTime = TimeOfDay(
                          hour: _startDate.hour, minute: _startDate.minute);
                      _endTime = TimeOfDay(
                          hour: _endDate.hour, minute: _endDate.minute);
                    });
                    Navigator.push<Widget>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const EventEditingPage()),
                    ).then((value) => setState(() {}));
                  } else {
                    // Remove the item from the data source.
                    setState(() {
                      _selectedAppointment =
                          moduleDataSource.appointments?[index];

                      moduleDataSource.appointments!.removeAt(moduleDataSource
                          .appointments!
                          .indexOf(_selectedAppointment));
                      moduleDataSource.notifyListeners(
                          CalendarDataSourceAction.remove,
                          <Module>[_selectedAppointment!]);
                      storage.writeTimetable(moduleDataSource.appointments);
                      _selectedAppointment = null;
                    });
                    setState(() {});
                  }
                },

                // Show a green/red background as the item is swiped right/left.
                background: Container(
                    color: Colors.green,  //edit
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.white),
                        Text('Edit Module',
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
                secondaryBackground: Container(
                  color: Colors.red,   //delete
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
                    leading: Icon(
                      Icons.circle_outlined,
                      color: tempAppointment!.background,
                    ),
                    title: Text(modTitle),
                  ),
                ));
          },
        ));
  }
}
