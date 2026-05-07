import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_happy_work_place/constants/app_routes.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/models/goals/goal_detail.dart';
import 'package:my_happy_work_place/utils/app_loader.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/utils/injectors.dart';
import 'package:my_happy_work_place/utils/utils.dart';
import 'package:my_happy_work_place/view_models/goals/goal_view_model.dart';
import 'package:my_happy_work_place/view_models/goals/goals_events.dart';
import 'package:my_happy_work_place/view_models/goals/goals_state.dart';
import 'package:my_happy_work_place/views/pages/goal/category_goal_listing.dart';
import 'package:my_happy_work_place/views/pages/goal/empty_goals_widget.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/color_constants.dart';
import '../../widgets/custom_text.dart';
import '../bottom_sheet/alert_bottom_sheet.dart';

class CategoryGoalsDetails extends StatefulWidget {
  const CategoryGoalsDetails({super.key});

  @override
  State<CategoryGoalsDetails> createState() => _CategoryGoalsDetailsState();
}

class _CategoryGoalsDetailsState extends State<CategoryGoalsDetails> {
  @override
  Widget build(BuildContext context) {
    final loaderCubit = context.read<LoaderCubit>();
    _getGoals(context, loaderCubit);

    return BlocBuilder<GoalsViewModel, GoalsState>(
        builder: (context, goalState) {
      if (goalState.goalsByCategory.isNotEmpty) {
        loaderCubit.hideLoader();
      }
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: CustomText(
              text: goalState.goalsByCategory.isNotEmpty ? goalState.goalsByCategory[0].title : AppConstants.emptyString,
              weight: FontWeight.w600,
              size: AppConstants.font18Px,
              textColor: ColorConstants.darkText,
            ),
          ),
          leading: GestureDetector(
              onTap: () {
                goalState.goalsByCategory = List.empty();
                Navigator.pop(context, true);
              },
              child: SvgPicture.asset(AppIcons.arrowBack)),
          backgroundColor: ColorConstants.homeScreenBackground,
          elevation: 0,
          actions: [
            GestureDetector(
                onTap: () async {
                  if (goalState.goalsByCategory[0].goals.active.length >= 2) {
                    _showErrorSheet();
                  }
                  else{
                    goalState.createGoalDetail = GoalDetail.defaultConstructor();
                    AppRouter.pushNamed(context: context, route: AppRoutes.createGoal);
                  }
                },
                child: SvgPicture.asset(AppIcons.navAdd)),
          ],
        ),
        body: SingleChildScrollView(
          child: goalState.goalsByCategory.isNotEmpty ?Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.standard),
            child: _ifGoalsAreEmpty(goalState)
                ? EmptyGoalsWidget(
                    categoryEmotion:
                        goalState.goalsByCategory[0].latestCategoryEmotion)
                : CategoryGoalListing(),
          ) : Container(
            color: ColorConstants.homeScreenBackground,
          ),
        ),
      );
    });
  }


  bool _ifGoalsAreEmpty(GoalsState goalState) {
    return goalState.goalsByCategory[0].goals.active.isEmpty == true &&
        goalState.goalsByCategory[0].goals.completed.isEmpty == true &&
        goalState.goalsByCategory[0].goals.givenUp.isEmpty == true;
  }

  void _getGoals(BuildContext context, LoaderCubit loaderCubit) {
    loaderCubit.showLoader();
    getIt<GoalsViewModel>().add(GetGoalsByCategory(
      onSuccess: ({required String message}) {
        loaderCubit.hideLoader();
        Utils.showSnackBar(message: message, context: context);
      },
      onError: ({required String error}) {
        loaderCubit.hideLoader();
        Utils.showSnackBar(message: error, context: context);
      },
    ));
  }

  Future<void> _showErrorSheet() async {
    await showModalBottomSheet(
      backgroundColor: ColorConstants.homeScreenBackground,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return BottomAlertSheet(
          firstMsg: AppConstants.haveReachedGoalLimit_1,
          secondMsg: AppConstants.haveReachedGoalLimit_2,
        );
      },
    );
  }
}
