import 'package:get_it/get_it.dart';
import 'package:my_happy_work_place/repositories/actions_repository.dart';
import 'package:my_happy_work_place/repositories/calendar_repository.dart';
import 'package:my_happy_work_place/repositories/goals_repository.dart';
import 'package:my_happy_work_place/repositories/home_repository.dart';
import 'package:my_happy_work_place/view_models/action/action_view_model.dart';
import 'package:my_happy_work_place/view_models/goals/goal_view_model.dart';
import 'package:my_happy_work_place/view_models/user_home/home_viewmodel.dart';

import '../managers/api_manager.dart';
import '../managers/api_manager_imp.dart';
import '../repositories/auth_repository.dart';
import '../view_models/auth/auth_view_model.dart';

final GetIt getIt = GetIt.instance;

class Injectors {
  static void initialize() {
    getIt.registerLazySingleton<ApiManager>(() => ApiManagerImpl());
    getIt.registerLazySingleton(
        () => AuthRepository(apiManager: getIt<ApiManager>()));
    getIt.registerLazySingleton(
        () => HomeRepository(apiManager: getIt<ApiManager>()));
    getIt.registerLazySingleton(
        () => GoalsRepository(apiManager: getIt<ApiManager>()));
    getIt.registerLazySingleton(
        () => ActionsRepository(apiManager: getIt<ApiManager>()));
    getIt.registerLazySingleton(
        () => CalendarRepository(apiManager: getIt<ApiManager>()));
    getIt.registerLazySingleton(
        () => AuthViewModel(authRepository: getIt<AuthRepository>()));
    getIt.registerLazySingleton(
        () => HomeViewModel(homeRepository: getIt<HomeRepository>(),
            calendarRepository: getIt<CalendarRepository>()));
    getIt.registerLazySingleton(() => GoalsViewModel(
        goalsRepository: getIt<GoalsRepository>(),
        calendarRepository: getIt<CalendarRepository>()));
    getIt.registerLazySingleton(() => ActionsViewModel(
        actionsRepository: getIt<ActionsRepository>(),
        calendarRepository: getIt<CalendarRepository>()));
  }
}
