import 'package:my_happy_work_place/models/dashboard/action.dart';
import 'package:my_happy_work_place/models/goals/action_progress.dart';

abstract class ActionEvents {
  final Function({required String message}) onSuccess;
  final Function({required String error}) onError;

  ActionEvents({required this.onError, required this.onSuccess});
}

class GetActionsByDateEvent extends ActionEvents {

  GetActionsByDateEvent({required super.onError, required super.onSuccess});
}

class UpdateActionStatus extends ActionEvents {
  final ActionProgress action;

  UpdateActionStatus(
      {required this.action, required super.onError, required super.onSuccess});
}

class CreateActionEvent extends ActionEvents {
  final GoalAction action;

  CreateActionEvent(
      {required this.action, required super.onSuccess, required super.onError});
}

class GetCategoriesEvent extends ActionEvents {

  GetCategoriesEvent({required super.onSuccess, required super.onError});
}

class ConnectCalendarEvent extends ActionEvents {

  ConnectCalendarEvent({required super.onSuccess, required super.onError});
}

class OnDateChanged extends ActionEvents{
  DateTime newDate;
  OnDateChanged({required this.newDate, required super.onError, required super.onSuccess});
}
