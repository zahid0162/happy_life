import 'dart:convert';

import 'package:my_happy_work_place/models/dashboard/category.dart';

class GoalAction {
  String? id;
  String goalId;
  Category category;
  String action;
  String frequency;
  DateTime? startDate;
  DateTime? estimatedEndDate;
  String startTime;
  String endTime;
  String status;
  bool isCompletedByUser = false;

  GoalAction({
    required this.id,
    required this.goalId,
    required this.category ,
    required this.action,
    required this.frequency,
    required this.startDate,
    required this.estimatedEndDate,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  // From JSON method
  factory GoalAction.fromJson(Map<String, dynamic> json) {
    return GoalAction(
      id: json['_id'] as String? ?? '',
      goalId: json['goal_id'] as String? ?? '',
      category:  Category.fromJson(json['category']),
      action: json['action'],
      frequency: json['frequency'],
      startDate: DateTime.parse(json['start_date']),
      estimatedEndDate: DateTime.parse(json['estimated_end_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
    );
  }

  GoalAction.defaultConstructor()
      : id = null,
        goalId = '',
        category = Category.defaultConstructor(),
        action = '',
        frequency = '',
        startDate = null,
        estimatedEndDate = null,
        startTime = '',
        endTime = '',
        status = '',
        isCompletedByUser = false;

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'goal_id': goalId,
      'category': jsonEncode(category.toJson()),
      'action': action,
      'frequency': frequency,
      'start_date': startDate?.toIso8601String(),
      'estimated_end_date': estimatedEndDate?.toIso8601String(),
      'start_time':startTime,
      'end_time': endTime,
      'status': status,
    };
  }

  Map<String, dynamic> toJsonWithoutCat() {
    return {
      'goal_id': goalId,
      'action': action,
      'frequency': frequency,
      'start_date': startDate?.toIso8601String(),
      'estimated_end_date': estimatedEndDate?.toIso8601String(),
      'start_time':startTime,
      'end_time': endTime,
      'status': status,
    };
  }

  // Helper method to parse time strings (e.g., "06:00") into DateTime objects
  static DateTime _parseTime(String time) {
    final timeParts = time.split(':');
    return DateTime(0, 1, 1, int.parse(timeParts[0]), int.parse(timeParts[1]));
  }

  // Helper method to format DateTime objects back to time strings (e.g., "06:00")
  static String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}