import 'package:dio/dio.dart';
import 'package:testflutt/api_url.dart';
import 'package:testflutt/data/model/category_sub_cate.dart';
import 'package:testflutt/dioClient.dart';

class CatSub {
  final Dio _dio = DioClient.dio;

  Future<List<Category>> getCategory(String? query) async {
    try {
      final response = await _dio.get(
        ApiUrl.getCategory,
        queryParameters: {"q": query},
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as List;

        return data.map((d) => Category.fromJson(d)).toList();
      }
      throw Exception("Error when get all category");
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<List<SubCategory>> getSUb(String? query) async {
    try {
      final response = await _dio.get(
        ApiUrl.getSubCate,
        queryParameters: {"q": query},
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as List;

        return data.map((d) => SubCategory.fromJson(d)).toList();
      }
      throw Exception("Error when get all sub-category");
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
