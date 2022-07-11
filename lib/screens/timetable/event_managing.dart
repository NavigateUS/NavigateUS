part of timetable;

class EventManagingPage extends StatefulWidget {
  const EventManagingPage({Key? key}) : super(key: key);

  @override
  EventManagingPageState createState() => EventManagingPageState();
}

class EventManagingPageState extends State<EventManagingPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
// floatingActionButton: _selectedAppointment == null
//                 ? const Text('', {required TextAlign textAlign})
//                 : FloatingActionButton(
//                     onPressed: () {
//                       if (_selectedAppointment != null) {
//                         moduleDataSource.appointments!.removeAt(moduleDataSource
//                             .appointments!
//                             .indexOf(_selectedAppointment));
//                         moduleDataSource.notifyListeners(
//                             CalendarDataSourceAction.remove,
//                             <Module>[_selectedAppointment!]);
//                         _selectedAppointment = null;
//                         Navigator.pop(context);
//                       }
//                     },
//                     backgroundColor: Colors.red,
//                     child:
//                         const Icon(Icons.delete_outline, color: Colors.white),
//                   )
// 