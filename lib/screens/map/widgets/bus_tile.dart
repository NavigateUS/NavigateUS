import 'package:flutter/material.dart';

Color busColor(String service) {
  Map<String, Color> busColors =
  {
    'A1' : Colors.red.shade400,
    'A2' : Colors.yellow.shade600,
    'D1' : Colors.purpleAccent,
    'D2' : Colors.deepPurpleAccent,
    'K' : Colors.blue,
    'E' : Colors.green
  };

  return busColors[service] ?? Colors.orange;
}

class BusTile extends StatelessWidget {
  final String stops;
  final String service;
  //final String waitTime;

  const BusTile({
    Key? key,
    required this.stops,
    required this.service,
    //required this.waitTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String stopsTaken = stops;
    stopsTaken += ' ';
    if (int.parse(stops) == 1) {
      stopsTaken += 'stop';
    }
    else{
      stopsTaken += 'stops';
    }


    return Container(
      padding: const EdgeInsets.all(2),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[400],
      ),
      child: Wrap(
        textDirection: TextDirection.ltr,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: busColor(service),
            ),
            child: Wrap(
              textDirection: TextDirection.ltr,
              children: [
                Text(service, style: const TextStyle(fontSize: 17), textDirection: TextDirection.ltr,)
              ],
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Text(stopsTaken, style: const TextStyle(fontSize: 18), textDirection: TextDirection.ltr,),
        ],
      ),
    );
  }
}
