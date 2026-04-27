

import 'package:my_happy_work_place/models/enum/goal_type_enum.dart';

import '../dashboard/category.dart';

class CategoryWithGoalsResponse {
  final String status;
  final String message;
  final List<Category> data;

  CategoryWithGoalsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryWithGoalsResponse.fromJson(Map<String, dynamic> json) {
    return CategoryWithGoalsResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}