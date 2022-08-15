import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/screens/map/widgets/detailed_directions.dart';
import 'package:navigateus/screens/map/functions/bus_directions_service.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
  
  testWidgets(
      'BusDirections widget gives widget for 1 direction instructions', (
      tester) async {
    final List<DirectionInstructions> instructions = [
      DirectionInstructions(['A1'], 4, 'COM 2', 'Kent Ridge MRT')
    ];
    
    Widget testWidget = DetailedDirections(instructions: instructions,
        startStop: 'COM 2',
        destination: 'Kent Ridge MRT');

    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    await tester.pumpAndSettle();

    final finder = find.byType(DetailedDirections);
    expect(finder, findsOneWidget);

    final tileFinder = find.byType(ListTile);
    expect(tileFinder, findsNWidgets(3));
  });

}