import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigateus/places.dart';
import 'package:navigateus/screens/map_screen.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Map screen has map, search bar, and floating action button, and directions', (tester) async {
    Widget testWidget = const MapScreen();
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    final mapFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(GoogleMap));
    expect(mapFinder, findsOneWidget);

    final searchFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(FloatingSearchBar));
    expect(searchFinder, findsOneWidget);

    final floatingActionButtonFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(FloatingActionButton));
    expect(floatingActionButtonFinder, findsOneWidget);

    final directionsFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(Visibility));
    expect(directionsFinder, findsOneWidget);
  });

  test('Expect visibility of directions to be false initially', () async {
    MapState testState = MapState();

    expect(testState.visibility, false);
  });


  test('Searching for places returns correct predictions', () {
    const widget = MapScreen();
    final element = widget.createElement();
    final state = element.state as MapState;
    
    state.autoCompleteSearch('COM');

    List<Place> expected = locations.sublist(0,3);
    expected.add(locations[26]);  //TCOMS
    expected.add(locations[59]);  //Computer Center
    
    expect(state.predictions, expected);
  });

}