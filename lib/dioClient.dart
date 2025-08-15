import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testflutt/api_url.dart';
import 'package:testflutt/auth_inteceptor.dart';
import 'package:testflutt/local.dart';
import 'package:testflutt/presentation/auth/login_screen.dart';

class DioClient {
  static late final Dio _dio;

  static Future<void> init(GlobalKey<NavigatorState> key) async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.json,
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
        sendTimeout: Duration(seconds: 10),
      ),
    );

    final auth = await AuthInteceptor.create(dio);
    dio.interceptors.add(auth);

    final storage = FlutterSecureStorage();
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.error is AuthExpiredException) {
            await storage.delete(key: Local.access);
            await storage.delete(key: Local.refresh);
            key.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (_) => false,
            );
          }
          handler.next(error);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor());
    _dio = dio;
  }

  static Dio get dio => _dio;
}
