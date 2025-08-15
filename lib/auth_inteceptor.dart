import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:testflutt/api_url.dart';
import 'package:testflutt/local.dart';

class AuthExpiredException implements Exception {
  final String? message;
  AuthExpiredException([this.message]);

  @override
  String toString() => message ?? 'AuthExpiredException';
}

class AuthInteceptor extends Interceptor {
  late final Dio _refreshDio;
  late final FlutterSecureStorage _storage;
  late final Dio _dio;

  AuthInteceptor._(this._refreshDio, this._storage, this._dio);

  static Future<AuthInteceptor> create(Dio mainDio) async {
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final storage = FlutterSecureStorage();
    return AuthInteceptor._(refreshDio, storage, mainDio);
  }

  Completer<bool>? _refreshing;

  Future<bool> _refresh() async {
    if (_refreshing != null) return _refreshing!.future;
    _refreshing = Completer<bool>();

    String? refresh = await _storage.read(key: Local.refresh);
    print('Refresh token = $refresh');

    try {
      if (refresh == null || JwtDecoder.isExpired(refresh)) {
        _refreshing!.complete(false);
        print('When refresh => token is expired or null');
        return false;
      }

      final response = await _refreshDio.post(
        ApiUrl.refresh,
        options: Options(headers: {'Authorization': 'Bearer $refresh'}),
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final newAccess = response.data['newAccess'];
        final newRefresh = response.data['newRefresh'];

        if (newAccess == null || newRefresh == null) {
          _refreshing!.complete(false);
          return false;
        }

        await _storage.write(key: Local.access, value: newAccess);
        await _storage.write(key: Local.refresh, value: newRefresh);

        _refreshing!.complete(true);
        return true;
      }
      _refreshing!.complete(false);
      return false;
    } catch (_) {
      _refreshing!.complete(false);
      return false;
    } finally {
      scheduleMicrotask(() => _refreshing = null);
    }
  }

  final publicPath = [
    '/auth/register',
    '/auth/mobile/login',
    '/auth/mobile/refresh',
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (publicPath.contains(options.uri.path)) {
      return handler.next(options);
    }
    String? access = await _storage.read(key: Local.access);

    if (access == null || JwtDecoder.isExpired(access)) {
      final refresh = await _refresh();
      if (!refresh) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
            error: AuthExpiredException('Refresh Failed'),
            type: DioExceptionType.cancel,
          ),
        );
      }
      access = await _storage.read(key: Local.access);
    }

    if (access != null) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;

    if (status == 401 && !publicPath.contains(err.requestOptions.uri.path)) {
      if (err.requestOptions.extra['__retried__'] == true) {
        return handler.next(err);
      }

      final refresh = await _refresh();

      if (refresh) {
        final newAccess = await _storage.read(key: Local.access);
        if (newAccess == null) {
          return handler.next(err);
        }
        final req = err.requestOptions;
        req.extra['__retried__'] = true;

        try {
          final resp = await _dio.request(
            req.path,
            data: req.data,
            queryParameters: req.queryParameters,
            options: Options(
              method: req.method,
              headers: {...req.headers, 'Authorization': 'Bearer $newAccess'},
              responseType: req.responseType,
              contentType: req.contentType,
            ),
          );
          handler.resolve(resp);
          return;
        } catch (_) {
          return handler.next(err);
        }
      } else {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: Response(
              requestOptions: err.requestOptions,
              statusCode: 401,
            ),
            error: AuthExpiredException('Refresh Failed'),
            type: DioExceptionType.cancel,
          ),
        );
      }
    }
    return handler.next(err);
  }
}
