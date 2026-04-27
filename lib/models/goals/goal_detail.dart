import 'dart:convert';

import 'package:my_happy_work_place/models/dashboard/action.dart';

import '../dashboard/category.dart';

class GoalDetailResponse {
  final String message;
  final String status;
  final GoalDetail goalDetail;

  GoalDetailResponse(
      {required this.message, required this.status, required this.goalDetail});

  factory GoalDetailResponse.fromJson(Map<String, dynamic> json) {
    return GoalDetailResponse(
        message: json['message'],
        status: json['status'],
        goalDetail: GoalDetail.fromJson(json['data']));
  }
}

class CreateActionResponse {
  final String message;
  final String status;
  final GoalAction goalAction;

  CreateActionResponse(
      {required this.message, required this.status, required this.goalAction});

  factory CreateActionResponse.fromJson(Map<String, dynamic> json) {
    return CreateActionResponse(
        message: json['message'],
        status: json['status'],
        goalAction: GoalAction.fromJson(json['data']));
  }
}

class GoalDetail {
  String id;
  String userId;
  String title;
  DateTime? startDate;
  DateTime? estimatedEndDate;
  DateTime? endDate;
  String status;
  String startingPoint;
  String happinessDetail;
  DateTime? createdAt;
  DateTime? updatedAt;
  int version;
  Category category;
  Actions actions;
  List<Obstacle> obstacles;

  GoalDetail({
    required this.id,
    required this.userId,
    required this.title,
    required this.startDate,
    required this.estimatedEndDate,
    this.endDate,
    required this.status,
    required this.startingPoint,
    required this.happinessDetail,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.category,
    required this.actions,
    required this.obstacles,
  });

  GoalDetail.defaultConstructor() :
    id = '',
    userId = '',
    title = '',
    startDate = null,
    estimatedEndDate = null,
    endDate = null,
    status = 'Active',
    startingPoint = '',
    happinessDetail = '',
    createdAt = null,
    updatedAt = null,
    version = 1,
    category = Category.defaultConstructor(),
    actions = Actions.defaultConstructor(),
    obstacles = [Obstacle.defaultConstructor()];

  factory GoalDetail.fromJson(Map<String, dynamic> json) {
    return GoalDetail(
      id: json['_id'],
      userId: json['user_id'],
      title: json['title'],
      startDate: DateTime.parse(json['start_date']),
      estimatedEndDate: DateTime.parse(json['estimated_end_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'],
      startingPoint: json['starting_point'],
      happinessDetail: json['happiness_detail'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
      category: Category.fromJson(json['category']),
      actions: Actions.fromJson(json['actions']),
      obstacles:
          (json['obstacles'] as List).map((e) => Obstacle.fromJson(e)).toList(),
    );
  }

  Map<String,dynamic> getCreateGoalBody(){
    return {
      'title': title,
      'start_date': startDate?.toIso8601String(),
      'estimated_end_date': estimatedEndDate?.toIso8601String(),
      'status': status,
      'starting_point': startingPoint,
      'happiness_detail': happinessDetail,
      'category_id': category.id,
      'actions': jsonEncode(actions.active.map((e) => e.toJson()).toList()),
      'obstacles': jsonEncode(obstacles.map((e) => e.toCreateJson()).toList()),
    };
  }
  Map<String,dynamic> getUpdateGoalBody(){
    return {
      'title': title,
      'start_date': startDate?.toIso8601String(),
      'estimated_end_date': estimatedEndDate?.toIso8601String(),
      'status': status,
      'starting_point': startingPoint,
      'happiness_detail': happinessDetail,
      'category_id': category.id,
      'obstacles': jsonEncode(obstacles.map((e) => e.toJson()).toList()),
    };
  }
}

class Actions {
  final List<GoalAction> active;
  final List<GoalAction> givenUp;
  final List<GoalAction> completed;
  final List<GoalAction> overDue;

  Actions({
    required this.active,
    required this.givenUp,
    required this.completed,
    required this.overDue
  });

  Actions.defaultConstructor()
      : active = [],
        givenUp = [],
        completed = [],
  overDue = [];

  factory Actions.fromJson(Map<String, dynamic> json) {
    return Actions(
      active:
          (json['active'] as List).map((e) => GoalAction.fromJson(e)).toList(),
      givenUp: (json['given-up'] as List)
          .map((e) => GoalAction.fromJson(e))
          .toList(),
      completed: (json['completed'] as List)
          .map((e) => GoalAction.fromJson(e))
          .toList(),
      overDue: (json['overdue'] as List)
          .map((e) => GoalAction.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': jsonEncode(active.map((e) => e.toJson()).toList()),
      'given-up': jsonEncode(givenUp.map((e) => e.toJson()).toList()),
      'completed': jsonEncode(completed.map((e) => e.toJson()).toList()),
      'overdue': jsonEncode(completed.map((e) => e.toJson()).toList()),
    };
  }
}

class Obstacle {
  String id;
  String goalId;
  String obstacle;
  String difficulty;
  DateTime? createdAt;
  DateTime? updatedAt;
  int version;

  Obstacle({
    required this.id,
    required this.goalId,
    required this.obstacle,
    required this.difficulty,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  Obstacle.defaultConstructor()
      : id = '',
        goalId = '',
        obstacle = '',
        difficulty = '',
        createdAt = null,
        updatedAt = null,
        version = 0;

  factory Obstacle.fromJson(Map<String, dynamic> json) {
    return Obstacle(
      id: json['_id'],
      goalId: json['goal_id'],
      obstacle: json['obstacle'],
      difficulty: json['difficulty'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'obstacle': obstacle,
      'difficulty': difficulty,
      'createdAt': createdAt?.toIso8601String() ?? '',
      'updatedAt': updatedAt?.toIso8601String() ?? '',
      '__v': version,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'goal_id': goalId,
      'obstacle': obstacle,
      'difficulty': difficulty,
      'createdAt': createdAt?.toIso8601String() ?? '',
      'updatedAt': updatedAt?.toIso8601String() ?? '',
      '__v': version,
    };
  }
}
