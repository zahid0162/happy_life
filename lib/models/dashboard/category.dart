import 'dart:ui';

import 'package:flutter_native_splash/cli_commands.dart';
import 'package:my_happy_work_place/models/enum/category_status_enum.dart';

import '../goals/category_with_goals_response.dart';
import '../goals/goal.dart';

class Category {
  final String id;
  String title;
  final String iconUrl;
  final String description;
  final List<Goal> goals;
  Color color;
  final bool isActive;

  Category( {
    required this.id,
    required this.iconUrl,
    required this.title,
    required this.description,
    required this.isActive,
    required this.goals,
    required this.color
  });

  Category.defaultConstructor()
      : id = '',
        title = '',
        iconUrl = '',
        description = '',
        goals = [],
        color = const Color(0xFFFFFFFF), // Default to white
        isActive = false;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isActive: json['is_active'] as bool,
      iconUrl: json['iconUrl'] as String,
      goals: (json['goals'] as List? ?? [])
          .map((item) => Goal.fromJson(item as Map<String, dynamic>))
          .toList(),
      color:   parseColor(json['color'] as String)

    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'iconUrl': iconUrl,
      'description': description,
      'is_active': isActive,
      'goals': goals.map((goal) => goal.toJson()).toList(),
      'color': '#${color.value.toRadixString(16).substring(2).toUpperCase()}', // Convert color to hex
    };
  }

  static Color parseColor(String colorString) {
    // Remove the '#' if it exists
    String hex = colorString.replaceFirst('#', '');
    // Convert to Color object
    return Color(int.parse('0xFF$hex'));
  }

}

class CategoryEmotion {
  final Category category;
  final String? userId;
  CategoryStatus emotion;

  CategoryEmotion({
    required this.category,
    required this.userId,
    required this.emotion,
  });

  factory CategoryEmotion.fromJson(Map<String, dynamic> json) {
    return CategoryEmotion(
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      userId: json['user_id'] as String?,
      emotion: CategoryStatus.fromJson(json['emotion'] as String?),
    );
  }
}

class UpdateCategoryResponse {
  final String message;
  final String status;
  final List<CategoryEmotion> categories;

  UpdateCategoryResponse(
      {required this.message, required this.status, required this.categories});

  factory UpdateCategoryResponse.fromJson(Map<String, dynamic> json){
    return UpdateCategoryResponse(message: json['message'] as String,
        status: json['status'] as String,
        categories: (json['data'] as List<dynamic>)
        .map((e) => CategoryEmotion.fromJson(e as Map<String, dynamic>))
        .toList());
  }
}

class SuccessResponse {
  final String message;
  final String status;

  SuccessResponse(
      {required this.message, required this.status});

  factory SuccessResponse.fromJson(Map<String, dynamic> json){
    return SuccessResponse(message: json['message'] as String,
        status: json['status'] as String,);
  }
}