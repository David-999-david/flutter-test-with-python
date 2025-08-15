import 'package:intl/intl.dart';

class Category {
  final int id;
  final String name;
  final DateTime createdAt;

  Category({required this.id, required this.name, required this.createdAt});

  String get formated => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class SubCategory {
  final int id;
  final int categoryId;
  final String name;
  final DateTime createdAt;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.createdAt,
  });

  String get formated => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      createdAt: json['created_at'],
    );
  }
}
