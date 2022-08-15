import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';
import 'package:navigateus/screens/indoor_maps/indoor_maps.dart';
import 'package:photo_view/photo_view.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Indoor Maps has title, text field, and buildings',
      (tester) async {
    Widget testWidget = const IndoorMap();
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    final titleFinder = find.text("Indoor Maps");
    expect(titleFinder, findsOneWidget);

    final textFieldFinder = find.descendant(
        of: find.byWidget(testWidget), matching: find.byType(TextField));
    expect(textFieldFinder, findsOneWidget);

    final buildingFinder = find.descendant(
        of: find.byWidget(testWidget), matching: find.byType(ImageButton));
    expect(buildingFinder, findsWidgets);
  });

  testWidgets('Indoor Maps has title, text field, and buildings',
      (tester) async {
    Widget testWidget = const FloorMap(
        building: "COM1", floorList: ['Basement', 'L1', 'L2', 'L3']);
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    final titleFinder = find.text("COM1");
    expect(titleFinder, findsOneWidget);

    final buttonFinder = find.byType(FloatingActionButton);
    expect(buttonFinder, findsNWidgets(4));

    final imageFinder = find.descendant(
        of: find.byWidget(testWidget), matching: find.byType(PhotoView));
    expect(imageFinder, findsOneWidget);
  });

  testWidgets('Main page search works', (tester) async {
    Widget testWidget = const IndoorMap();
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    await tester.enterText(find.byType(TextField), 'COM');

    final com1Finder = find.text("COM1");
    expect(com1Finder, findsOneWidget);

    final com2Finder = find.text("COM2");
    expect(com2Finder, findsOneWidget);
  });
}
