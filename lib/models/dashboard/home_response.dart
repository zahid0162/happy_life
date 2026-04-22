import 'package:my_happy_work_place/models/dashboard/action.dart';
import 'package:my_happy_work_place/models/goals/action_progress.dart';

import 'category.dart';



class HomeResponseData {
  final bool hasHistoricalEmotions;
  final List<CategoryEmotion> categoryEmotions;
  final List<ActionProgress> upcomingActions;
  final List<GoalAction> alerts;


  HomeResponseData({
    required this.upcomingActions,
    required this.alerts,
    required this.hasHistoricalEmotions,
    required this.categoryEmotions,
  });

  factory HomeResponseData.fromJson(Map<String, dynamic> json) {
    return HomeResponseData(
      hasHistoricalEmotions: json['data']['has_historical_emotions'] as bool,
      categoryEmotions: (json['data']['categoryEmotions'] as List<dynamic>)
          .map((e) => CategoryEmotion.fromJson(e as Map<String, dynamic>))
          .toList(),
      upcomingActions: (json['data']['upcoming_actions'] as List<dynamic>)
          .map((e) => ActionProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts: (json['data']['alerts'] as List<dynamic>)
          .map((e) => GoalAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  HomeResponseData copyWith({
    bool? hasHistoricalEmotions,
    List<CategoryEmotion>? categoryEmotions,
    List<ActionProgress>? actions,
    List<GoalAction>? alerts,
  }) {
    return HomeResponseData(
      hasHistoricalEmotions: hasHistoricalEmotions ?? this.hasHistoricalEmotions,
      categoryEmotions: categoryEmotions ?? this.categoryEmotions,
      upcomingActions: actions ?? this.upcomingActions,
      alerts: alerts ?? this.alerts
    );
  }
}