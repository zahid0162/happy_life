import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_happy_work_place/repositories/actions_repository.dart';
import 'package:my_happy_work_place/repositories/calendar_repository.dart';
import 'package:my_happy_work_place/utils/injectors.dart';
import 'package:my_happy_work_place/utils/preference_helper.dart';
import 'package:my_happy_work_place/view_models/action/_action_event.dart';
import 'package:my_happy_work_place/view_models/action/action_state.dart';

class ActionsViewModel extends Bloc<ActionEvents, ActionState> {
  final ActionsRepository actionsRepository;
  final CalendarRepository calendarRepository;

  ActionsViewModel(
      {required this.actionsRepository, required this.calendarRepository})
      : super(ActionState(
            currentDate: DateTime.now(),
            categories: List.empty(),
            actions: List.empty(),
            selectedCategory: null,
            selectedGoal: null,
            key: 0)) {
    on<GetActionsByDateEvent>(_getActionByDate);
    on<CreateActionEvent>(_createAction);
    on<GetCategoriesEvent>(_getInitialData);
    on<UpdateActionStatus>(_updateActionStatus);
    on<ConnectCalendarEvent>(_connectCalendar);
    on<OnDateChanged>(_onDateChanged);
  }

  Future<void> _getInitialData(
      GetCategoriesEvent event, Emitter<ActionState> emit) async {
    state.isCalendarConnected =
        await SharedPreferencesHelper.getOutlookStatus();
    emit(state.copyWith(key: Random().nextInt(1000)));
    final response = await actionsRepository.getCategoriesWithGoals();
    if (response.data != null) {
      emit(state.copyWith(
          categories: response.data!.data, key: Random().nextInt(1000)));
      event.onSuccess(message: "");
    } else {
      event.onError(
          error: response.error?.message ?? "Unable to load data, try again.");
    }
  }

  Future<void> _getActionByDate(
      GetActionsByDateEvent event, Emitter<ActionState> emit) async {
    final response = await actionsRepository
        .getActionProgresses(state.currentDate.toIso8601String());
    if (response.data != null) {
      emit(state.copyWith(
          key: Random().nextInt(1000),
          actions: response.data!.actionsProgressList));
      event.onSuccess(message: response.data?.message ?? '');
    } else {
      event.onError(error: response.error?.message ?? 'Unable to get Actions');
    }
  }

  FutureOr<void> _createAction(
      CreateActionEvent event, Emitter<ActionState> emit) async {
    if (await SharedPreferencesHelper.getOutlookStatus()) {
      await refreshCalendarToken();
    }
    final response = await actionsRepository.createNewAction(event.action);
    if (response.data != null) {
      event.onSuccess(message: response.data!.message);
    } else {
      event.onError(
          error:
              response.error?.message ?? "Unable to create action, try again!");
    }
  }

  Future<void> refreshCalendarToken() async {
    final calendarToken = await calendarRepository.refreshCalendarToken();
    if(calendarToken !=null) await calendarRepository.saveCalendarToken(calendarToken);
  }

  Future<void> _updateActionStatus(
      UpdateActionStatus event, Emitter<ActionState> emit) async {
    if (event.action.action.id != null) {
      final response = await actionsRepository.updateEventStatus(
          event.action.action.id ?? '', 'completed');
      if (response.data != null) {
        final index = state.actions.indexOf(event.action);
        state.actions[index].status = 'completed';
        emit(state.copyWith(key: Random().nextInt(1000)));
        event.onSuccess(
            message: response.data?.message ?? "Action updated successfully");
      } else {
        event.onError(
            error: response.error?.message ?? "Unable to update action status");
      }
    }
  }

  Future<void> _connectCalendar(
      ConnectCalendarEvent event, Emitter<ActionState> emit) async {
    final token = await calendarRepository.connectOutlookCalendar();
    if (token != null && token.isNotEmpty) {
      final response = await calendarRepository.saveCalendarToken(token);
      if (response.data != null) {
        await SharedPreferencesHelper.saveOutlookStatus(true);
        state.isCalendarConnected = true;
        emit(state.copyWith(key: Random().nextInt(1000)));
        event.onSuccess(message: "");
      } else {
        await SharedPreferencesHelper.saveOutlookStatus(false);
        event.onError(
            error: response.data?.message ??
                'unable to proceed, please try again');
      }
    } else {
      await SharedPreferencesHelper.saveOutlookStatus(false);
      event.onError(error: 'unable to proceed, please try again');
    }
  }

  Future<void> _onDateChanged(
      OnDateChanged event, Emitter<ActionState> emit) async {
    state.currentDate = event.newDate;
    emit(state.copyWith(key: Random().nextInt(1000)));
  }
}
