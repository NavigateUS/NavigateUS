import 'package:flutter/material.dart';

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

    Color col;
    if (service == 'A1') {
      col = Colors.red.shade400;
    }
    else if (service == 'A2') {
      col = Colors.yellow.shade600;
    }
    else if (service == 'D1') {
      col = Colors.purpleAccent;
    }
    else if (service == 'D2') {
      col = Colors.deepPurpleAccent;
    }
    else if (service == 'K') {
      col = Colors.blue;
    }
    else if (service == 'E') {
      col = Colors.green;
    }
    else {
      col = Colors.orange;
    }


    return Row(
      children: [
        Container(
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
                  color: col,
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
        ),

      ],
    );
  }
}
