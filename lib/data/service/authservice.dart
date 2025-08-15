import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:testflutt/api_url.dart';
import 'package:testflutt/data/model/auth_model.dart';
import 'package:testflutt/dioClient.dart';
import 'package:testflutt/local.dart';

class Authservice {
  final Dio _dio = DioClient.dio;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> register(RegisterModel user) async {
    try {
      final response = await _dio.post(ApiUrl.register, data: user.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Register success, please check email from eamil verify!');
      }
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> login(LoginModel user) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: user.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final access = response.data['access'];
        final refresh = response.data['refresh'];

        if (access == null || refresh == null) {
          throw Exception('ACCESS or REFRESH is missing when after login');
        }
        
        await _storage.write(key: Local.access, value: access);
        await _storage.write(key: Local.refresh, value: refresh);

        final seeRefresh = await _storage.read(key: Local.refresh);
        print('Refresh store => $seeRefresh');
      }
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> handlerStart() async {
    String? refresh = await _storage.read(key: Local.refresh);

    if (refresh == null) {
      print('refresh is null');
      return false;
    }

    if (!JwtDecoder.isExpired(refresh)) {
      print('refresh not expired');
      return true;
    }

    try {
      final response = await _dio.post(
        ApiUrl.refresh,
        options: Options(headers: {'Authorization': 'Bearer $refresh'}),
      );
      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final newAccess = response.data['newAccess'];
        final newRefresh = response.data['newRefresh'];
        if (newAccess == null || newRefresh == null) {
          print('False refresh');
          return false;
        }
        await _storage.write(key: Local.access, value: newAccess);
        await _storage.write(key: Local.refresh, value: newRefresh);
        print('True refresh');
        return true;
      }
    } on DioException catch (e) {
      print('Error Failed to refresh both token $e');
      return false;
    }
    print('False refresh');
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: Local.access);
    await _storage.delete(key: Local.refresh);
  }
}
