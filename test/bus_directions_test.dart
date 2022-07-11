import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/widgets/bus_directions.dart';
import 'package:navigateus/mapFunctions/bus_directions_service.dart';
import 'package:navigateus/widgets/bus_tile.dart';

void main() {
  testWidgets('BusDirections widget gives widget for 1 direction instructions', (tester) async {
    const testKey = Key('K');
    final List<DirectionInstructions> instructions = [DirectionInstructions(['A1'], 4)];

    await tester.pumpWidget(BusDirections(instructions: instructions, key: testKey));
    
    final tileFinder = find.byKey(testKey);

    expect(tileFinder, findsOneWidget);
  });

  testWidgets('BusDirections widget gives widget for multiple direction instructions', (tester) async {
    const testKey = Key('K');
    final List<DirectionInstructions> instructions = [DirectionInstructions(['A1'], 2), DirectionInstructions(['A2'], 2)];

    await tester.pumpWidget(BusDirections(instructions: instructions, key: testKey));

    final tileFinder = find.byKey(testKey);

    expect(tileFinder, findsOneWidget);
  });
}