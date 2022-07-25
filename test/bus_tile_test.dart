import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/screens/map/widgets/bus_tile.dart';

void main() {
  test('Given bus A1, expect Colors.red.shade400', () async {
    const bus = 'A1';

    final result = busColor(bus);

    expect(result, Colors.red.shade400);
  });



  testWidgets('BusTile widget has bus and stops for 1 stop, along with containers', (tester) async {
    await tester.pumpWidget(const BusTile(stops: '1', service: 'A1'));

    final stopsFinder = find.text('1 stop');
    final busFinder = find.text('A1');

    expect(stopsFinder, findsOneWidget);
    expect(busFinder, findsOneWidget);
  });



  testWidgets('BusTile widget has bus and stops for multiple stops', (tester) async {
    await tester.pumpWidget(const BusTile(stops: '2', service: 'A1'));

    final stopsFinder = find.text('2 stops');
    final busFinder = find.text('A1');

    expect(stopsFinder, findsOneWidget);
    expect(busFinder, findsOneWidget);
  });
}
