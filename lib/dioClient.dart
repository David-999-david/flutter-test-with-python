import 'package:dio/dio.dart';
import 'package:testflutt/api_url.dart';


class DioClient {
  static late final _dio;

  static Future<void> init() async {
    final Dio dio = Dio(
      BaseOptions(
          baseUrl: ApiUrl.baseUrl,
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 60),
          sendTimeout: Duration(seconds: 10)),
    );

    dio.interceptors.add(LogInterceptor());
    _dio = dio;
  }

  static Dio get dio {
    if (_dio == null) {
      throw Exception('Error in dio call');
    }
    return _dio;
  }
}
