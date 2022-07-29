import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/screens/map/widgets/bus_directions.dart';
import 'package:navigateus/screens/map/functions/bus_directions_service.dart';

void main() {
  testWidgets('BusDirections widget gives widget for 1 direction instructions', (tester) async {
    const testKey = Key('K');
    final List<DirectionInstructions> instructions = [DirectionInstructions(['A1'], 4, 'COM 2', 'Kent Ridge MRT')];

    await tester.pumpWidget(BusDirections(instructions: instructions, key: testKey));
    
    final tileFinder = find.byKey(testKey);

    expect(tileFinder, findsOneWidget);
  });

  testWidgets('BusDirections widget gives widget for multiple direction instructions', (tester) async {
    const testKey = Key('K');
    final List<DirectionInstructions> instructions = [DirectionInstructions(['A1'], 1, 'COM 2', 'BIZ 2'), DirectionInstructions(['D1'], 1, 'BIZ 2', 'COM 3')];

    await tester.pumpWidget(BusDirections(instructions: instructions, key: testKey));

    final tileFinder = find.byKey(testKey);

    expect(tileFinder, findsOneWidget);
  });
}