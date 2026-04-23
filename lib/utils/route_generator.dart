
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/models/enum/goal_type_enum.dart';
import 'package:my_happy_work_place/views/pages/actions_views/create_new_action.dart';
import 'package:my_happy_work_place/views/pages/create_goal/add_goal_actions.dart';
import 'package:my_happy_work_place/views/pages/create_goal/add_obstacle.dart';
import 'package:my_happy_work_place/views/pages/create_goal/create_goal_action.dart';
import 'package:my_happy_work_place/views/pages/create_goal/create_goal_general_info.dart';
import 'package:my_happy_work_place/views/pages/edit_goal/edit_goal_action.dart';
import 'package:my_happy_work_place/views/pages/edit_goal/edit_goal_general_info.dart';
import 'package:my_happy_work_place/views/pages/edit_goal/edit_obstacle.dart';
import 'package:my_happy_work_place/views/pages/goal/category_goals_details.dart';
import 'package:my_happy_work_place/views/pages/auth/sign_up.dart';
import 'package:my_happy_work_place/views/pages/complete_profile/picture_info.dart';
import 'package:my_happy_work_place/views/pages/complete_profile/profile_location.dart';
import 'package:my_happy_work_place/views/pages/goal/goal_detail.dart';
import 'package:my_happy_work_place/views/pages/goal/goals_listing_by_type.dart';
import 'package:my_happy_work_place/views/pages/home_screen/home_screen.dart';
import 'package:my_happy_work_place/views/pages/notification/NotificationsScreen.dart';
import 'package:my_happy_work_place/views/pages/onboarding/explore.dart';
import 'package:my_happy_work_place/views/pages/onboarding/welcome_dart.dart';
import 'package:my_happy_work_place/views/pages/settings/category_support_screen.dart';
import 'package:my_happy_work_place/views/pages/settings/edit_profile.dart';
import 'package:my_happy_work_place/views/pages/settings/main_settings_screen.dart';
import 'package:my_happy_work_place/views/pages/settings/my_calendar.dart';

import '../constants/app_routes.dart';
import '../models/goals/goal_detail.dart';
import '../views/pages/auth/sign_in.dart';
import '../views/pages/onboarding/splash.dart';

class RouteGenerator {

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return buildRoute(const Splash(), settings: settings);
      case AppRoutes.login:
        return buildRoute(const SignIn(), settings: settings);
      case AppRoutes.signUp:
        return buildRoute(const SignUp(), settings: settings);
      case AppRoutes.welcome:
        return buildRoute(const WelcomeScreen(), settings: settings);
      case AppRoutes.welcome_2:
        return buildRoute(const ExploreAppScreen(), settings: settings);
      case AppRoutes.profileInfo:
        return buildRoute(const ProfileScreen(), settings: settings);
      case AppRoutes.categoryGoalDetails:
        return buildRoute(const CategoryGoalsDetails(), settings: settings);
      case AppRoutes.locationInfo:
        return buildRoute(const ProfileLocationInfo(), settings: settings);
      case AppRoutes.homeScreen:
        return buildRoute(HomeScreen(), settings: settings);
      case AppRoutes.goalListByType:
        return buildRoute(CategoryGoalListingByType(), settings: settings);
      case AppRoutes.goalDetails:
        return buildRoute(GoalDetailsView(), settings: settings);
      case AppRoutes.createGoal:
        return buildRoute(CreateGoalGeneralInfo(), settings: settings);
      case AppRoutes.addObstacle:
        return buildRoute(AddObstacleView(), settings: settings);
      case AppRoutes.addActions:
        return buildRoute(AddGoalActions(), settings: settings);
      case AppRoutes.createGoalAction:
        return buildRoute(CreateGoalAction(), settings: settings);
      case AppRoutes.editGoalInfo:
        return buildRoute(EditGoalGeneralInfo(), settings: settings);
      case AppRoutes.editObstacleInfo:
        return buildRoute(EditObstacleView(), settings: settings);
      case AppRoutes.editActionInfo:
        return buildRoute(EditGoalAction(), settings: settings);
      case AppRoutes.createAction:
        return buildRoute(CreateNewAction(), settings: settings);
      case AppRoutes.settings:
        return buildRoute(MainSettingsScreen(), settings: settings);
      case AppRoutes.editProfile:
        return buildRoute(EditProfile(), settings: settings);
      case AppRoutes.userCalendar:
        return buildRoute(MyCalendar(), settings: settings);
      case AppRoutes.categorySupport:
        return buildRoute(CategorySupportScreen(), settings: settings);
      case AppRoutes.notifications:
        return buildRoute(NotificationsScreen(), settings: settings);

    }
  }


  static CupertinoPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return CupertinoPageRoute(
        settings: settings, builder: (BuildContext context) => child);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            AppConstants.invalidRoute,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child:  Text(
            AppConstants.routeDoesNotExist,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}