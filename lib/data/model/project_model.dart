import 'package:intl/intl.dart';

class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdAt,
  });

  String get formated => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class insertProject {
  final String title;
  final String description;
  final int sub_id;

  insertProject({
    required this.title,
    required this.description,
    required this.sub_id,
  });

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description, "sub_id": sub_id};
  }
}
