import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Future<Response> getArrival(String stop, List<String> bus) async {

  final dio = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: dio);

  const path = 'https://mocknusbus.com';

  final String readResponse = await rootBundle.loadString('assets/bus_arrival.json');
  final data = await json.decode(readResponse);

  Map<String, String> arrivals = {};

  for (String b in bus) {
    arrivals[b] = data[stop][b]["next"];
  }


  dioAdapter.onGet(
    path,
        (server) => server.reply(
      200, arrivals,
    ),
  );

  final response = await dio.get(path);

  return response;
}