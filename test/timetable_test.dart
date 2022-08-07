import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/screens/timetable/timetable_screen.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Timetable has two buttons', (tester) async {
    Widget testWidget = const TimetableScreen();
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    final floatingActionButtonFinder = find.descendant(
        of: find.byWidget(testWidget),
        matching: find.byType(FloatingActionButton));
    expect(floatingActionButtonFinder, findsNWidgets(2));
  });

  testWidgets('Add module', (tester) async {
    Widget testWidget = const TimetableScreen();
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    await tester.tap(find.byIcon(Icons.add));
  });
}
