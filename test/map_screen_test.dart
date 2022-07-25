import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:navigateus/key.dart';
import 'package:navigateus/places.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/map/map_screen.dart';
import 'package:navigateus/screens/map/widgets/bus_directions.dart';

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

    List<Place> expected = nusLocations.values.toList().sublist(0,3);
    expected.add(nusLocations["TCOMS"]!);  //TCOMS
    expected.add(nusLocations["Computer Centre"]!);  //Computer Center
    
    expect(state.predictions, expected);
  });

  testWidgets('Bottom sheet shows required text and buttons', (tester) async {
    Widget testWidget = const MapScreen(key: Key('K'));
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    await tester.pumpAndSettle();

    final MapState mapState = tester.state(find.byKey(const Key('K')));

    mapState.bottomSheet(mapState.context, nusLocations["COM 1"]!);

    await tester.pumpAndSettle();

    final textFinder = find.text('COM 1');
    expect(textFinder, findsOneWidget);

    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsNWidgets(4));
  });
}