import 'package:flutter/material.dart';
import 'package:navigateus/screens/bus_route/bus_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class BusRoutes extends StatefulWidget {
  const BusRoutes({Key? key}) : super(key: key);

  @override
  State<BusRoutes> createState() => _BusRoutesState();
}

class _BusRoutesState extends State<BusRoutes> {
  List<String> busses = ['A1', 'A2', 'D1', 'D2', 'K', 'E'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Routes"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          // Image.asset("assets/bus_routes/Map.jpg"),
          Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PhotoViewGallery.builder(
                    backgroundDecoration: const BoxDecoration(color: Colors.white),
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        maxScale: PhotoViewComputedScale.contained * 2.0,
                        minScale: PhotoViewComputedScale.contained,
                        imageProvider: const AssetImage("assets/bus_routes/Map.jpg"),
                        initialScale: PhotoViewComputedScale.contained,
                      );
                    },
                    itemCount: 1,
                  ),
                ),
              ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.deepOrange,
            child: const Center(
              child: Text('View Details',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),),
            ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: busses.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(busses[index]),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BusPage(service: busses[index],)));
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) { return const Divider(thickness: 2,); },
              ),
            ),
          )
        ],
      )
    );
  }
}
