import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/screens/indoor_maps/components/image_button.dart';
import 'package:navigateus/screens/indoor_maps/detail_screen.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';
import 'package:navigateus/screens/indoor_maps/indoor_maps.dart';
import 'package:photo_view/photo_view.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}){
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Indoor Maps has title, text field, and buildings', (tester) async {
    Widget testWidget = const IndoorMap();
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    final titleFinder = find.text("Indoor Maps");
    expect(titleFinder, findsOneWidget);

    final textFieldFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(TextField));
    expect(textFieldFinder, findsOneWidget);

    final buildingFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(ImageButton));
    expect(buildingFinder, findsWidgets);
  });

  testWidgets('Indoor Maps building has title and floors', (tester) async {
    Widget testWidget = const FloorMap(building: "COM1", floorNum: 3, hasBasement: true);
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    final titleFinder = find.text("COM1");
    expect(titleFinder, findsOneWidget);

    final floorFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(ImageButton));
    expect(floorFinder, findsWidgets);
  });

  testWidgets('Details page has title and image', (tester) async {
    Widget testWidget = const DetailScreen(floor: 'COM1 L1', image: "assets/indoor_maps/COM1_L1.jpg");
    await tester.pumpWidget(createWidgetForTesting(child: testWidget));

    final titleFinder = find.text("COM1 L1");
    expect(titleFinder, findsOneWidget);

    final imageFinder = find.descendant(of: find.byWidget(testWidget), matching: find.byType(PhotoView));
    expect(imageFinder, findsWidgets);
  });

}
