import 'package:flutter_test/flutter_test.dart';
import 'package:navigateus/screens/map/functions/bus_directions_service.dart';

//Unit testing for bus_directions_service
void main() {
  test('Given bus stop Kent Ridge Bus Terminal When getNeighbours is called then the correct neighbours are returned', () async {
    const stop = 'Kent Ridge Bus Terminal';

    final result = getNeighbours(stop);

    expect(result,
        [
          {
            "bus": "A1",
            "nextBusStop": "LT 13",
          },
          {
            "bus": "A2",
            "nextBusStop": "Information Technology",
          },
        ]);
  });

  test('Given user location at COM 2 bus stop and destination at Kent Ridge MRT, the correct path is returned', () async {
    const start = 'COM 2';
    const end = 'Kent Ridge MRT';

    final result = findRoute(start, end);

    const route = [['A1'], ['A1'], ['A1'], ['D2', 'A1']];

    expect(result, route);
  });

  test('Given the above route, the correct instructions are returned', () async {
    const route = [['A1'], ['A1'], ['A1'], ['D2', 'A1']];

    final result = getBestRoute(route, 'COM 2');

    expect(result, [DirectionInstructions(['A1'], 4, 'COM 2', 'Kent Ridge MRT'),]);
  });
}