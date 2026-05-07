import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/app_routes.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/models/enum/goal_type_enum.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/utils/injectors.dart';
import 'package:my_happy_work_place/view_models/goals/goal_view_model.dart';
import 'package:my_happy_work_place/view_models/goals/goals_state.dart';
import 'package:my_happy_work_place/views/pages/goal/item_goal.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/color_constants.dart';
import '../../widgets/custom_text.dart';

class CategoryGoalListing extends StatelessWidget {
  const CategoryGoalListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsViewModel, GoalsState>(
        builder: (context, goalState) {
      return SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: Spacing.xxxxlarge,
          ),
          Container(
            padding: EdgeInsets.all(Spacing.standard),
            decoration: BoxDecoration(
              color: ColorConstants.goalsCatBg,
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppConstants.currentFeeling,
                  size: AppConstants.font14Px,
                  weight: FontWeight.w500,
                  textColor: ColorConstants.blackInputText,
                ),
                SvgPicture.asset(
                  goalState.goalsByCategory[0].latestCategoryEmotion.emotion.iconName,
                  width: AppConstants.defaultIconSize,
                  height: AppConstants.defaultIconSize,
                ),
              ],
            ),
          ),
          SizedBox(
            height: Spacing.xxxxlarge,
          ),
          if (goalState.goalsByCategory[0].goals.active.isNotEmpty)
            GoalItem(goal: goalState.goalsByCategory[0].goals.active[0]),
          if (goalState.goalsByCategory[0].goals.active.length == 2)
            GoalItem(goal: goalState.goalsByCategory[0].goals.active[1]),
          if (goalState.goalsByCategory[0].goals.completed.isNotEmpty) ...[
            SizedBox(
              height: Spacing.xxlarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppConstants.completedGoals,
                  size: AppConstants.font18Px,
                  weight: FontWeight.w600,
                  textColor: ColorConstants.darkText,
                ),
                GestureDetector(
                  onTap: () {
                    goalState.currentTypeForListing = GoalTypes.COMPLETED;
                    AppRouter.pushNamed(
                        context: context, route: AppRoutes.goalListByType);
                  },
                  child: CustomText(
                    text: AppConstants.seeMore,
                    size: AppConstants.font14Px,
                    weight: FontWeight.w500,
                    textColor: ColorConstants.blackInputText.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Spacing.xxlarge,
            ),
            GoalItem(goal: goalState.goalsByCategory[0].goals.completed[0]),
          ],

          if (goalState.goalsByCategory[0].goals.givenUp.isNotEmpty) ...[
            SizedBox(
              height: Spacing.xxlarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppConstants.givenGoals,
                  size: AppConstants.font18Px,
                  weight: FontWeight.w600,
                  textColor: ColorConstants.darkText,
                ),
                GestureDetector(
                  onTap: () {
                    goalState.currentTypeForListing = GoalTypes.GIVEUP;
                    AppRouter.pushNamed(
                        context: context, route: AppRoutes.goalListByType);
                  },
                  child: CustomText(
                    text: AppConstants.seeMore,
                    size: AppConstants.font14Px,
                    weight: FontWeight.w500,
                    textColor: ColorConstants.blackInputText.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Spacing.xxlarge,
            ),
            GoalItem(goal: goalState.goalsByCategory[0].goals.givenUp[0]),
          ],
        ]),
      );
    });
  }
}
