import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigateus/screens/indoor_maps/floor_map.dart';

class Place {
  late final String name;
  late final LatLng latLng;
  late final FloorMap? indoorMap;

  Place(this.name, this.latLng, {this.indoorMap});

  static DropdownMenuItem<String> toDropdown(Place place) {
    return DropdownMenuItem(
      value: place.name,
      child: Text(place.name),
    );
  }

  static List<DropdownMenuItem<String>> getDropdownList() {
    List<DropdownMenuItem<String>> list = [];
    for (Place place in nusLocations.values) {
      list.add(toDropdown(place));
    }
    return list;
  }

  @override
  String toString() {
    return name;
  }
}

Map<String, Place> nusLocations = {
  "COM 1": Place("COM 1", const LatLng(1.2950768299309143, 103.773546809054),
      indoorMap: const FloorMap(
          building: "COM1", floorList: ['Basement', 'L1', 'L2', 'L3'])),
  "COM 2": Place("COM 2", const LatLng(1.294632390948073, 103.77414904894421),
      indoorMap: const FloorMap(
          building: "COM2", floorList: ['Basement', 'L1', 'L2', 'L3', 'L4'])),
  "COM 3": Place("COM 3", const LatLng(1.2954803776871135, 103.77468480930364)),
  "Icube Building": Place(
      "Icube Building", const LatLng(1.2923243394779413, 103.77536909282506),
      indoorMap: const FloorMap(building: "ICUBE", floorList: ['L1', 'L3'])),
  "BIZ 1, Mochtar Riady Building": Place("BIZ 1, Mochtar Riady Building",
      const LatLng(1.2926680252746072, 103.77425677288579)),
  "BIZ 2": Place("BIZ 2", const LatLng(1.2935537033095423, 103.77511694696383)),
  "AS 1": Place("AS 1", const LatLng(1.295152959369053, 103.77207431006603)),
  "AS 2": Place("AS 2", const LatLng(1.2953995904615376, 103.77110780984086)),
  "AS 3": Place("AS 3", const LatLng(1.2950516041186084, 103.77079352829908),
      indoorMap: const FloorMap(building: "AS3", floorList: ['L6'])),
  "AS 4": Place("AS 4", const LatLng(1.2946428045673408, 103.77183775406685)),
  "AS 5": Place("AS 5", const LatLng(1.293906289506983, 103.77174651103859)),
  "AS 6": Place("AS 6", const LatLng(1.2955583803389359, 103.77323005510064),
      indoorMap:
          const FloorMap(building: "AS6", floorList: ['L2', 'L4', 'L5'])),
  "AS 7, The Shaw Foundation Building": Place(
      "AS 7, The Shaw Foundation Building",
      const LatLng(1.294284682597709, 103.77101656678427)),
  "AS 8": Place("AS 8", const LatLng(1.296010888377147, 103.77204160552967)),
  "Central Library": Place(
      "Central Library", const LatLng(1.2964815913034848, 103.77262614588378)),
  "Ventus":
      Place("Ventus", const LatLng(1.295417875913936, 103.77022107162308)),
  "Kent Ridge Bus Terminal": Place("Kent Ridge Bus Terminal",
      const LatLng(1.2943251047092783, 103.76978739220405)),
  "Eusoff Hall":
      Place("Eusoff Hall", const LatLng(1.293853156333056, 103.77038820700811)),
  "Temasek Hall": Place(
      "Temasek Hall", const LatLng(1.2929808301017303, 103.77141905690885)),
  "Kent Ridge Hall": Place(
      "Kent Ridge Hall", const LatLng(1.2919369247950556, 103.77478427720996)),
  "Sheares Hall": Place(
      "Sheares Hall", const LatLng(1.2915642455890586, 103.77565886220714)),
  "King Edward VII Hall": Place("King Edward VII Hall",
      const LatLng(1.2924635266531035, 103.78099666606704)),
  "NUSS Kent Ridge Guild House": Place("NUSS Kent Ridge Guild House",
      const LatLng(1.2933270239675878, 103.77305992098387)),
  "Shaw Foundation Alumni House": Place("Shaw Foundation Alumni House",
      const LatLng(1.293262667346585, 103.77337910387416)),
  "NUS Institute of Systems Science": Place("NUS Institute of Systems Science",
      const LatLng(1.2922249876831267, 103.7766063341464)),
  "Innovation 4.0": Place(
      "Innovation 4.0", const LatLng(1.2943019163067662, 103.77593823603979)),
  "TCOMS": Place("TCOMS", const LatLng(1.2936138096194254, 103.77693250500758)),
  "PGP Terminal": Place(
      "PGP Terminal", const LatLng(1.2918725303868497, 103.78050582390426)),
  "Prince George's Park Residences": Place("Prince George's Park Residences",
      const LatLng(1.2910771704544672, 103.78065952143682)),
  "Kent Ridge MRT Station (CC24)": Place("Kent Ridge MRT Station (CC24)",
      const LatLng(1.2935042617439856, 103.78462756519191)),
  "Raffles Hall": Place(
      "Raffles Hall", const LatLng(1.2999986193731659, 103.77335935677749)),
  "Kouk Foundation House": Place("Kouk Foundation House",
      const LatLng(1.3004759296368251, 103.77355247581431)),
  "LT1": Place("LT1", const LatLng(1.3047322714394691, 103.77258010419182)),
  "LT2": Place("LT2", const LatLng(1.299851253053853, 103.7710016825985)),
  "LT3": Place("LT3", const LatLng(1.2976431913336597, 103.77330624999533)),
  "LT4": Place("LT4", const LatLng(1.2975064337544742, 103.77357178867096)),
  "LT5": Place("LT5", const LatLng(1.29905422003288, 103.77126638431183)),
  "LT6": Place("LT6", const LatLng(1.298768581559815, 103.77196402955505)),
  "LT7A": Place("LT7A", const LatLng(1.3005661637389188, 103.77088359673752)),
  "LT8": Place("LT8", const LatLng(1.2942091457429876, 103.77193179140238)),
  "LT9": Place("LT9", const LatLng(1.2949926928352409, 103.77226360430436)),
  "Engineering EA": Place(
      "Engineering EA", const LatLng(1.3005481307632891, 103.77074781610281)),
  "LT7": Place("LT7", const LatLng(1.3003141010356785, 103.77108208019203)),
  "Engineering E1": Place(
      "Engineering E1", const LatLng(1.2989077012103507, 103.7710953910105)),
  "Engineering E2": Place(
      "Engineering E2", const LatLng(1.2991436749370524, 103.77126437016773)),
  "Engineering E3": Place(
      "Engineering E3", const LatLng(1.299520812859213, 103.77176607834234)),
  "Engineering E4": Place(
      "Engineering E4", const LatLng(1.2984307897929301, 103.77242420732959)),
  "E5, NUS Chemical & Biomolecular Engineering": Place(
      "E5, NUS Chemical & Biomolecular Engineering",
      const LatLng(1.2980609893199393, 103.77242101762776)),
  "Engineering E6": Place(
      "Engineering E6", const LatLng(1.2994199215102638, 103.77301366537175)),
  "Engineering E7": Place(
      "Engineering E7", const LatLng(1.2986631817063243, 103.7735123052119)),
  "SDE1": Place("SDE1", const LatLng(1.2975147167201484, 103.7707988082049)),
  "SDE2": Place("SDE2", const LatLng(1.2973288967728525, 103.77114778408844)),
  "SDE3": Place("SDE3", const LatLng(1.2983110877682043, 103.7703929340795)),
  "CELC": Place("CELC", const LatLng(1.2970255172377436, 103.77143227529784)),
  "SDE4": Place("SDE4", const LatLng(1.2968965809243043, 103.7703056901086)),
  "NUS College of Design and Engineering, EA": Place(
      "NUS College of Design and Engineering, EA",
      const LatLng(1.3002767367745305, 103.77072694642754)),
  "Techno Edge Canteen": Place("Techno Edge Canteen",
      const LatLng(1.2979802160295313, 103.77175258028188)),
  "LT10": Place("LT10", const LatLng(1.2948844584090413, 103.77201663145598)),
  "LT11": Place("LT11", const LatLng(1.2954589248518809, 103.77140788818951)),
  "Computer Centre": Place(
      "Computer Centre", const LatLng(1.2975978252094893, 103.77250941773869)),
  "LT13": Place("LT13", const LatLng(1.2951114375092163, 103.77082256350303)),
  "LT12": Place("LT12", const LatLng(1.295083281509476, 103.77095935615412)),
  "Chinese Library": Place(
      "Chinese Library", const LatLng(1.2969874915032293, 103.77336791756645)),
  "LT14": Place("LT14", const LatLng(1.2957378362556056, 103.77337051216836)),
  "LT15": Place("LT15", const LatLng(1.2955197820813862, 103.77348999847628)),
  "LT16": Place("LT16", const LatLng(1.2939607148127243, 103.77386486311178)),
  "LT17": Place("LT17", const LatLng(1.2935960388701353, 103.77398204628271)),
  "LT18": Place("LT18", const LatLng(1.2935712351289619, 103.77449629111868)),
  "LT19": Place("LT19", const LatLng(1.2937426063903663, 103.77439705088737)),
  "LT21": Place("LT21", const LatLng(1.2959699228909902, 103.77806829554784)),
  "LT27": Place("LT27", const LatLng(1.2970818194337372, 103.78079820607518)),
  "LT28": Place("LT28", const LatLng(1.2975467409107213, 103.78122412540655)),
  "LT29": Place("LT29", const LatLng(1.2971865308714334, 103.78130341421564)),
  "LT31": Place("LT31", const LatLng(1.2971002971003498, 103.78042032054235)),
  "LT32": Place("LT33", const LatLng(1.2979804291146089, 103.78104550204267)),
  "LT33": Place("LT33", const LatLng(1.2979804291146089, 103.78104550204267)),
  "LT35, Peter and Mary Fu Lecture Theatre": Place(
      "LT35, Peter and Mary Fu Lecture Theatre",
      const LatLng(1.2956339858521257, 103.78124630185256)),
  "LT36, Alice and Peter Tan Lecture Theatre": Place(
      "LT36, Alice and Peter Tan Lecture Theatre",
      const LatLng(1.2956339858521257, 103.78124630185256)),
  "The Deck":
      Place("The Deck", const LatLng(1.2947174133627448, 103.77247781588338)),
  "Synchrotron Light Source": Place("Synchrotron Light Source",
      const LatLng(1.295577005414589, 103.77487692321124)),
  "Institute of Materials Research & Engineering": Place(
      "Institute of Materials Research & Engineering",
      const LatLng(1.2945710579299403, 103.775770117641)),
  "NUS Hon Sui Sen Memorial Library": Place("NUS Hon Sui Sen Memorial Library",
      const LatLng(1.2930661408110764, 103.7745774877126)),
  "University Cultural Centre": Place("University Cultural Centre",
      const LatLng(1.3016029913851732, 103.77197550071276)),
  "Yong Siew Toh Conservatory of Music": Place(
      "Yong Siew Toh Conservatory of Music",
      const LatLng(1.302407446321917, 103.77274529465119)),
  "Lee Kong Chian Natural History Museum": Place(
      "Lee Kong Chian Natural History Museum",
      const LatLng(1.3015010937415459, 103.77351508858963)),
  "NUS Museum":
      Place("NUS Museum", const LatLng(1.3013402027168905, 103.77270237930968)),
  "Music Library": Place(
      "Music Library", const LatLng(1.3018228757600563, 103.7728901339288)),
  "Runme Shaw CFA Studio": Place("Runme Shaw CFA Studio",
      const LatLng(1.299232754612182, 103.7737639227557)),
  "Yusof Ishak House, YIH": Place("Yusof Ishak House, YIH",
      const LatLng(1.2985207931081364, 103.77490441384862)),
  "Ridge View Residential College": Place("Ridge View Residential College",
      const LatLng(1.2982894663142115, 103.77618652103136)),
  "University Health Centre, UHC": Place("University Health Centre, UHC",
      const LatLng(1.2990399412448408, 103.77642016599934)),
  "University Sports Centre, USC": Place("University Sports Centre, USC",
      const LatLng(1.2995852400523222, 103.77545528115782)),
  "MPSH6": Place("MPSH6", const LatLng(1.3002372516411902, 103.77562552206695)),
  "MPSH5": Place("MPSH5", const LatLng(1.300394629584414, 103.77626088577071)),
  "MPSH1,2,3,4":
      Place("MPSH1,2,3,4", const LatLng(1.3008364254324378, 103.7759801877826)),
  "NUS Staff Club": Place(
      "NUS Staff Club", const LatLng(1.2992524085748836, 103.77584923471703)),
  "Singapore Wind Tunnel Facility": Place("Singapore Wind Tunnel Facility",
      const LatLng(1.3010860150329828, 103.77532293390252)),
  "Institute of Systems Science": Place("Institute of Systems Science",
      const LatLng(1.292221360619686, 103.77657846669928)),
  "Temasek Life Sciences Laboratory": Place("Temasek Life Sciences Laboratory",
      const LatLng(1.294281932817939, 103.77702858776357)),
  "NUS Enterprise Incubator": Place("NUS Enterprise Incubator",
      const LatLng(1.2931556104321842, 103.77797289583887)),
  "Institute For Mathematical Sciences": Place(
      "Institute For Mathematical Sciences",
      const LatLng(1.2929425521253117, 103.77934323104577)),
  "Office of Campus Security": Place("Office of Campus Security",
      const LatLng(1.2924070580397131, 103.7793567485317)),
  "University Hall": Place(
      "University Hall", const LatLng(1.2972313489570002, 103.77784277639833)),
  "S12": Place("S12", const LatLng(1.2970175692769044, 103.77851905380602)),
  "S13": Place("S13", const LatLng(1.2967494170876008, 103.77928616553564)),
  "S11": Place("S11", const LatLng(1.2966367931610159, 103.77872826610681)),
  "S14": Place("S14", const LatLng(1.2968228364256535, 103.77971403649381)),
  "S15": Place("S15", const LatLng(1.2971527616948006, 103.78030198499326)),
  "S16": Place("S16", const LatLng(1.2971527616948006, 103.78030198499326)),
  "S1": Place("S1", const LatLng(1.2956843441598866, 103.77804799072416)),
  "S2": Place("S2", const LatLng(1.2955265023299, 103.77831864590047)),
  "S3": Place("S3", const LatLng(1.295526260467711, 103.77864262166219)),
  "LT20": Place("LT20", const LatLng(1.2958212324632155, 103.77879891705246)),
  "Science Library": Place(
      "Science Library", const LatLng(1.2952067410687025, 103.78011342348931)),
  "S4A, Department of Pharmacy": Place("S4A, Department of Pharmacy",
      const LatLng(1.2958404927199125, 103.77919066205354)),
  "S4": Place("S4", const LatLng(1.2956539428687004, 103.77923212817748)),
  "S5,Pharmaceutical Society": Place("S5,Pharmaceutical Society",
      const LatLng(1.2955136318604572, 103.77965157396972)),
  "MD1, Tahir Foundation Building": Place("MD1, Tahir Foundation Building",
      const LatLng(1.2954801485463923, 103.78050003471697)),
  "Saw Swee Hock School of Public Health": Place(
      "Saw Swee Hock School of Public Health",
      const LatLng(1.2952043098334172, 103.78064516615078)),
  "Centre for Life Science": Place("Centre for Life Science",
      const LatLng(1.2944024946076491, 103.78079045762864)),
  "Medical Library": Place(
      "Medical Library", const LatLng(1.2951861845665, 103.78180453651736)),
  "MD2": Place("MD2", const LatLng(1.2950818044187127, 103.78189612144347)),
  "MD3": Place("MD3", const LatLng(1.2956312763024285, 103.7815508087525)),
  "MD4": Place("MD4", const LatLng(1.2956524377057002, 103.78134875655618)),
  "Faculty of Dentistry": Place("Faculty of Dentistry",
      const LatLng(1.2968540510700888, 103.78200853139842)),
  "S17": Place("S17", const LatLng(1.2977254867342594, 103.78059181005091)),
  "LT34": Place("LT34", const LatLng(1.2977809221877168, 103.78069038724905)),
  "LT35": Place("LT35", const LatLng(1.2977501247137138, 103.7809861188435)),
  "MD6, Centre for Translational Medicine": Place(
      "MD6, Centre for Translational Medicine",
      const LatLng(1.2951759041030368, 103.78185916658924)),
  "MD10": Place("MD10", const LatLng(1.2965076153377928, 103.78190841435897)),
  "MD9": Place("MD9", const LatLng(1.2966893817983844, 103.78130556071082)),
  "Yong Loo Lin School Of Medicine": Place("Yong Loo Lin School Of Medicine",
      const LatLng(1.29647099517614, 103.78141288432064)),
  "MD7": Place("MD7", const LatLng(1.2961168091392752, 103.7808694218168)),
  "LT25": Place("LT25", const LatLng(1.2961007200010755, 103.78068569047845)),
  "LT24": Place("LT24", const LatLng(1.2958419530379823, 103.78062668187874)),
  "LT26": Place("LT26", const LatLng(1.296497118779455, 103.78102855213146)),
  "Residential College 4": Place("Residential College 4",
      const LatLng(1.308348262834349, 103.77309793371494)),
  "Cendana College": Place(
      "Cendana College", const LatLng(1.3080673650214574, 103.77216584699734)),
  "Yale-NUS College": Place(
      "Yale-NUS College", const LatLng(1.3068500596028008, 103.77222653845536)),
  "College of Alice & Peter Tan, CAPT": Place(
      "College of Alice & Peter Tan, CAPT",
      const LatLng(1.3077010878194157, 103.77319405385222)),
  "Chua Thian Poh Hall": Place("Chua Thian Poh Hall",
      const LatLng(1.3069836041457248, 103.77332536335831)),
  "Cinnamon College": Place(
      "Cinnamon College", const LatLng(1.306628303887504, 103.77353994007078)),
  "Tembusu College": Place(
      "Tembusu College", const LatLng(1.3061442910021301, 103.77374915237792)),
  "University Scholar Programme": Place("University Scholar Programme",
      const LatLng(1.3066866429625206, 103.77309594258536)),
  "Education Resource Centre": Place("Education Resource Centre",
      const LatLng(1.306241055910097, 103.77288162585833)),
  "School of Continuing and Lifelong Education": Place(
      "School of Continuing and Lifelong Education",
      const LatLng(1.3055698310037305, 103.77288541906343)),
  "Utown Residence": Place(
      "Utown Residence", const LatLng(1.3052076728552606, 103.77407838556205)),
  "Create":
      Place("Create", const LatLng(1.3039488322746062, 103.7740486452938)),
  "Stephen Riady Centre": Place("Stephen Riady Centre",
      const LatLng(1.3045914718148488, 103.77259612913134)),
  "Saga College": Place(
      "Saga College", const LatLng(1.305860599197163, 103.77201966902363)),
  "Elm College": Place(
      "Elm College", const LatLng(1.3063724555706304, 103.77203545724225)),
};
