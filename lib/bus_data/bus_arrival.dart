import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Future<Response> getArrival(String stop, List<String> bus) async {
  final dio = Dio(BaseOptions());
  final dioAdapter = DioAdapter(dio: dio);

  const path = 'https://mocknusbus.com';

  Map<String, String> res =  {'message': 'Success!'};

  dioAdapter.onGet(
    path,
        (server) => server.reply(
      200,
      res,
    ),
  );

  final response = await dio.get(path);

  return response;
}