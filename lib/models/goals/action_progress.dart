import 'package:my_happy_work_place/models/dashboard/action.dart';

class ActionProgress {
  String id;
  String date;
  String startTime;
  String endTime;
  String status;
  int version;
  DateTime createdAt;
  DateTime updatedAt;
  GoalAction action;

  ActionProgress({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.action,
  });

  factory ActionProgress.fromJson(Map<String, dynamic> json) {
    return ActionProgress(
      id: json['_id'],
      date: json['date'] as String? ?? '',
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      version: json['__v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      action: GoalAction.fromJson(json['action']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      '__v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'action': action.toJson(),
    };
  }
}

class MainActionResponse {
  String message;
  String status;
  List<ActionProgress> actionsProgressList;

  MainActionResponse(
      {required this.message,
      required this.status,
      required this.actionsProgressList});

  static MainActionResponse fromJson(Map<String, dynamic> json) {
    return MainActionResponse(
      message: json['message'],
      status: json['status'],
      actionsProgressList: (json['data'] as List)
          .map((item) => ActionProgress.fromJson(item))
          .toList(),
    );
  }
}
