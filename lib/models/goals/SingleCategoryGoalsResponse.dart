
import 'package:my_happy_work_place/models/dashboard/category.dart';

import '../enum/category_status_enum.dart';
import 'goal.dart';

class SingleCategoryGoalsResponse {
  final String status;
  final String message;
  final List<CategoryWithGoals> data;

  SingleCategoryGoalsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SingleCategoryGoalsResponse.fromJson(Map<String, dynamic> json) {
    return SingleCategoryGoalsResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => CategoryWithGoals.fromJson(item))
          .toList(),
    );
  }
}

class CategoryWithGoals {
  final String id;
  final String title;
  final String iconUrl;
  final String description;
  final bool isActive;
  final dynamic deletedAt;
  final int v;
  final LatestCategoryEmotion latestCategoryEmotion;
  final Goals goals;

  CategoryWithGoals({
    required this.id,
    required this.title,
    required this.iconUrl,
    required this.description,
    required this.isActive,
    this.deletedAt,
    required this.v,
    required this.latestCategoryEmotion,
    required this.goals,
  });

  factory CategoryWithGoals.fromJson(Map<String, dynamic> json) {
    return CategoryWithGoals(
      id: json['_id'],
      title: json['title'],
      iconUrl: json['iconUrl'],
      description: json['description'],
      isActive: json['is_active'],
      deletedAt: json['deleted_at'],
      v: json['__v'],
      latestCategoryEmotion: LatestCategoryEmotion.fromJson(json['latest_category_emotion']),
      goals: Goals.fromJson(json['goals']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'iconUrl': iconUrl,
      'description': description,
      'is_active': isActive,
      'deleted_at': deletedAt,
      '__v': v,
      'latest_category_emotion': latestCategoryEmotion.toJson(),
      'goals': goals.toJson(),
    };
  }
}


class LatestCategoryEmotion {
  final String id;
  final CategoryStatus  emotion;

  LatestCategoryEmotion({
    required this.id,
    required this.emotion,
  });

  factory LatestCategoryEmotion.fromJson(Map<String, dynamic> json) {
    return LatestCategoryEmotion(
      id: json['_id'],
      emotion: CategoryStatus.fromJson(json['emotion'] as String?)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'emotion': emotion,
    };
  }
}

class Goals {
  final List<Goal> active;
  final List<Goal> completed;
  final List<Goal> givenUp;

  Goals({
    required this.active,
    required this.completed,
    required this.givenUp,
  });

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      active: (json['active'] as List)
          .map((item) => Goal.fromJson(item))
          .toList(),
      completed: (json['completed'] as List)
          .map((item) => Goal.fromJson(item))
          .toList(),
      givenUp: (json['given-up'] as List)
          .map((item) => Goal.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active.map((item) => item.toJson()).toList(),
      'completed': completed.map((item) => item.toJson()).toList(),
      'given-up': givenUp.map((item) => item.toJson()).toList(),
    };
  }
}

