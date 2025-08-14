import 'package:dio/dio.dart';
import 'package:testflutt/api_url.dart';
import 'package:testflutt/data/model/auth_model.dart';
import 'package:testflutt/dioClient.dart';

class Authservice {
  final Dio _dio = DioClient.dio;

  Future<void> register(RegisterModel user)async{
    try {
      final response = await _dio.post(ApiUrl.register, data: user.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300){
        print('Register success, please check email from eamil verify!');
      }
    }
    on DioException catch (e){
      throw Exception(e);
    }
  }

  // Future<bool> checkLinkForverify() async {

  // } 
}