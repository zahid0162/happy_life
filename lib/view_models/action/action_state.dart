import 'package:equatable/equatable.dart';

import 'package:my_happy_work_place/models/dashboard/action.dart';
import 'package:my_happy_work_place/models/goals/action_progress.dart';

import '../../models/dashboard/category.dart';
import '../../models/goals/goal.dart';

class ActionState extends Equatable {
  int key;
  List<ActionProgress> actions;
  List<Category> categories;
  Category? selectedCategory;
  DateTime currentDate;
  Goal? selectedGoal;
  bool? isCalendarConnected;

  ActionState(
      {required this.actions,
        required this.currentDate,
        required this.categories,
        this.isCalendarConnected,
      required this.selectedCategory,
      required this.selectedGoal,
      required this.key});

  @override
  List<Object?> get props => [key, actions, selectedCategory, selectedGoal, categories, isCalendarConnected];

  ActionState copyWith({List<ActionProgress>? actions,required int key, List<Category>? categories, bool? isCalendarConnected}) {
    return ActionState(
      categories: categories ?? this.categories,
        currentDate: currentDate,
        isCalendarConnected: isCalendarConnected ?? this.isCalendarConnected,
        actions: actions ?? this.actions,
        key: key,
        selectedCategory: this.selectedCategory,
        selectedGoal: this.selectedGoal);
  }
}
