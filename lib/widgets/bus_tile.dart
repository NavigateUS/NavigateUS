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
    String text = stops;
    text += ' ';
    if (int.parse(stops) == 1) {
      text += 'stop';
    }
    else{
      text += 'stops';
    }


    return Container(
      padding: const EdgeInsets.all(2),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[400],
      ),
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: busColor(service),
            ),
            child: Wrap(
              children: [
                Text(service, style: const TextStyle(fontSize: 17),)
              ],
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Text(text, style: const TextStyle(fontSize: 18),),
        ],
      ),
    );
  }
}
