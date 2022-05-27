import 'package:flutter/material.dart';

void bottomSheet(BuildContext context, String name, var id) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
            children: [
              Center(
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 10,),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //walk
                            ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(const StadiumBorder()),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.directions_walk),
                                    Text('Walk')
                                  ],
                                ),
                            ),
                            const SizedBox(width: 10,),

                            //drive
                            ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(const StadiumBorder()),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.directions_car),
                                  Text('Drive')
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),

                            //transit
                            ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(const StadiumBorder()),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.directions_bus),
                                  Text('Transit')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3,),

                      ElevatedButton(
                        onPressed: () {
                          viewIndoorMap(id);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                          maximumSize: MaterialStateProperty.all(const Size.fromWidth(300))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.map_outlined),
                            Text('View Indoor Map')
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  )
              )
            ]
        );
      }
  );
}

void viewIndoorMap(id) {
  var available = [
    'ChIJW-fkx_ga2jERSjkkKeJjaUM', //com1
    'ChIJRafctPga2jER8aiJ3XzHihM' //com2
    ];

  //ToDo: navigate to indoor map
}