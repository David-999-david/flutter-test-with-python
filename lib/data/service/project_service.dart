import 'package:dio/dio.dart';
import 'package:testflutt/api_url.dart';
import 'package:testflutt/data/model/project_model.dart';
import 'package:testflutt/dioClient.dart';

class ProjectService {
  final Dio _dio = DioClient.dio;

  Future<ProjectModel> createProject(FormData form) async {
    try {
      final response = await _dio.post(
        ApiUrl.createProject,
        data: form,
        // options: Options(contentType: 'multipart/form-data'),
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;

        return ProjectModel.fromJson(data);
      } else {
        throw Exception('Failed Server when insert project');
      }
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
