import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  static bool graphStatus = false;

  @override
  void initState() {
    super.initState();
    SettingStorage().readSetting().then((value) {
      setState(() {
        graphStatus = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Setting"),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Include Bus K and E",
                            style: TextStyle(fontSize: 16),
                          ),
                          FlutterSwitch(
                            value: graphStatus,
                            onToggle: (val) {
                              setState(() {
                                graphStatus = val;
                                SettingStorage().writeSetting(val);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                          "Would you like to include Bus K and E in the transit direction? This may affect the suggested routes."),
                      Container(
                          alignment: Alignment.centerRight,
                          child: Text("Value: $graphStatus")),
                    ]))));
  }
}

class SettingStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/setting.txt');
  }

  Future<File> writeSetting(bool status) async {
    final file = await _localFile;
    return file.writeAsString('$status');
  }

  Future<bool> readSetting() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      if (contents.contains("true")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
