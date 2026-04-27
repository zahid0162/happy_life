



import 'package:my_happy_work_place/models/enum/goal_type_enum.dart';

class Goal {
  final String id;
  final String userId;
  final String categoryId;
  final String title;
  final DateTime startDate;
  final DateTime estimatedEndDate;
  final dynamic endDate;
  final String status;
  final String startingPoint;
  final String happinessDetail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final int totalActions;
  final int completedActions;
  final String progress;
  final String? goalType;

  Goal({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.startDate,
    required this.estimatedEndDate,
    this.endDate,
    this.goalType ,
    required this.status,
    required this.startingPoint,
    required this.happinessDetail,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.totalActions,
    required this.completedActions,
    required this.progress,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['_id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      title: json['title'],
      startDate: DateTime.parse(json['start_date']),
      estimatedEndDate: DateTime.parse(json['estimated_end_date']),
      endDate: json['end_date'],
      status: json['status'],
      startingPoint: json['starting_point'],
      happinessDetail: json['happiness_detail'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      totalActions: json['totalActions'],
      completedActions: json['completedActions'],
      progress: json['progress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'start_date': startDate.toIso8601String(),
      'estimated_end_date': estimatedEndDate.toIso8601String(),
      'end_date': endDate,
      'status': status,
      'starting_point': startingPoint,
      'happiness_detail': happinessDetail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'totalActions': totalActions,
      'completedActions': completedActions,
      'progress': progress,
    };
  }
}
