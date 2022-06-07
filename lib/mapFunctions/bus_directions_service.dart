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

  print('Route is: ');
  print(route);
  return route;
}

