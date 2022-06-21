import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';

class Place {
  late final String name;
  late final LatLng latLng;
  late final FloorMap? indoorMap;

  Place(this.name, this.latLng, {this.indoorMap});
}

List<Place> locations = [
  Place("COM 1", const LatLng(1.2950768299309143, 103.773546809054), indoorMap: const FloorMap(building: "COM1", floorNum: 3, hasBasement: true)),
  Place("COM 2", const LatLng(1.294632390948073, 103.77414904894421), indoorMap: const FloorMap(building: "COM2", floorNum: 4, hasBasement: true)),
  Place("COM 3", const LatLng(1.2954803776871135, 103.77468480930364)),
  Place("Icube Building", const LatLng(1.2924834421459082, 103.77532597934874)),
  Place("BIZ 1, Mochtar Riady Building", const LatLng(1.2926680252746072, 103.77425677288579)),
  Place("BIZ 2", const LatLng(1.2935537033095423, 103.77511694696383)),
  Place("AS 1", const LatLng(1.295152959369053, 103.77207431006603)),
  Place("AS 2", const LatLng(1.2953995904615376, 103.77110780984086)),
  Place("AS 3", const LatLng(1.2950516041186084, 103.77079352829908)),
  Place("AS 4", const LatLng(1.2946428045673408, 103.77183775406685)),
  Place("AS 5", const LatLng(1.293906289506983, 103.77174651103859)),
  Place("AS 6", const LatLng(1.2955583803389359, 103.77323005510064)),
  Place("AS 7, The Shaw Foundation Building", const LatLng(1.294284682597709, 103.77101656678427)),
  Place("AS 8", const LatLng(1.296010888377147, 103.77204160552967)),
  Place("Central Library", const LatLng(1.2964815913034848, 103.77262614588378)),
  Place("Ventus", const LatLng(1.295417875913936, 103.77022107162308)),
  Place("Kent Ridge Bus Terminal", const LatLng(1.2943251047092783, 103.76978739220405)),
  Place("Eusoff Hall", const LatLng(1.293853156333056, 103.77038820700811)),
  Place("Temasek Hall", const LatLng(1.2929808301017303, 103.77141905690885)),
  Place("Kent Ridge Hall", const LatLng(1.2919369247950556, 103.77478427720996)),
  Place("Sheares Hall", const LatLng(1.2915642455890586, 103.77565886220714)),
  Place("King Edward VII Hall", const LatLng(1.2924635266531035, 103.78099666606704)),
  Place("NUSS Kent Ridge Guild House", const LatLng(1.2933270239675878, 103.77305992098387)),
  Place("Shaw Foundation Alumni House", const LatLng(1.293262667346585, 103.77337910387416)),
  Place("NUS Institute of Systems Science", const LatLng(1.2922249876831267, 103.7766063341464)),
  Place("Innovation 4.0", const LatLng(1.2943019163067662, 103.77593823603979)),
  Place("TCOMS", const LatLng(1.2936138096194254, 103.77693250500758)),
  Place("PGP Terminal", const LatLng(1.2918725303868497, 103.78050582390426)),
  Place("Prince George's Park Residences", const LatLng(1.2910771704544672, 103.78065952143682)),
  Place("Kent Ridge MRT Station (CC24)", const LatLng(1.2935042617439856, 103.78462756519191)),
];