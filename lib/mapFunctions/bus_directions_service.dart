import 'package:navigateus/bus_data/bus_stops.dart';
import 'package:collection/collection.dart';

class Node implements Comparable{
  int stops;
  String name;

  Node(this.stops, this.name);

  @override
  int compareTo(other) {
    return stops.compareTo(other.stops);
  }

  String toString() {
    return '($stops, $name)';
  }
}

class DirectionInstructions{
  List<String> bus;
  int stops;

  DirectionInstructions(this.bus, this.stops);

  String toString() {
    return 'Take bus(es) $bus for $stops stops.';
  }
}


List<Map<String, String>>? getNeighbours(String stopName) {
  return graph[stopName];
}

List<List<String>> findRoute(String source, String destination) {  //Djikstra's to find shortest path
  Map<String, int> D = {}; //Distance array
  for (String key in graph.keys) {
    D[key] = 1000;
  }

  Map<String, String> p = {}; //Predecessor array
  for (String key in graph.keys) {
    p[key] = "";
  }

  Map<String, List<String>> pBus = {}; //Predecessor array for bus taken
  for (String key in graph.keys) {
    pBus[key] = [];
  }

  PriorityQueue<Node> q = PriorityQueue();

  D[source] = 0;
  p[source] = source;
  q.add(Node(0, source));

  while (q.isNotEmpty) {
    Node current = q.removeFirst();
    List<Map<String, String>> neighbours = getNeighbours(current.name)!;

    if (current.stops == D[current.name]) {
      for (var neighbour in neighbours) {

        String neighbourName = neighbour["nextBusStop"]!;
        if (neighbourName == "") {  //end of bus line, no next stop
          continue;
        }
        String bus = neighbour["bus"]!;

        if (D[current.name] == null || D[neighbourName] == null) {
          throw Exception("Invalid name");
        }


        if (D[neighbourName]! > D[current.name]! + 1) {  //Relaxation
          D[neighbourName] = D[current.name]! + 1;
          p[neighbourName] = current.name;
          q.add(Node(D[neighbourName]!, neighbourName));
        }

        if (D[neighbourName]! == D[current.name]! + 1) { //add viable busses
          pBus[neighbourName]!.add(bus);
        }
      }
    }
  }

  String tracking = destination;
  List<List<String>> route = [];

  while (p[tracking] != source) {
    route.add(pBus[tracking]!);
    tracking = p[tracking]!;
  }
  route.add(pBus[tracking]!);
  route = List.from(route.reversed);
  return route;
}

List<DirectionInstructions> getBestRoute(List<List<String>> route) {
  List<String> onBus = route[0];
  int counter = 0;
  List<DirectionInstructions> instructions = [];



  for (int i = 0; i < route.length; i++) {
    List<String> current = route[i];

    if (route[i] == onBus) {
      counter++;
    }
    else {
      List<String> testCurrent = [];
      for (String bus in current) { //track buses that continue the route
        if (onBus.contains(bus)) {
          testCurrent.add(bus);
        }
      }
      if (testCurrent.isNotEmpty) { //if there are buses that continue the route
        onBus = testCurrent;  //only include buses that do not need to change bus
        counter++;
      }
      else { //forced to change buses
        instructions.add(DirectionInstructions(onBus, counter));
        counter = 1;
        onBus = current;
      }
    }
  }
  instructions.add(DirectionInstructions(onBus, counter));
  return instructions;
}

