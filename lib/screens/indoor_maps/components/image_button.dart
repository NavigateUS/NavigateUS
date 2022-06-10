import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String name;
  final String image;
  final Widget newScreen;

  const ImageButton({
    Key? key,
    required this.name,
    required this.image,
    required this.newScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white,
          elevation: 8,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
              splashColor: Colors.black26,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => newScreen));
              },
              child: Column(
                children: [
                  Ink.image(
                      image: AssetImage(image),
                      height: size.height * 0.2,
                      width: size.width * 0.75,
                      fit: BoxFit.cover),
                  const SizedBox(height: 2),
                  Text(name,
                      style:
                          const TextStyle(fontSize: 25, color: Colors.black)),
                  const SizedBox(height: 2),
                ],
              )),
        ),
      ),
    );
  }
}
