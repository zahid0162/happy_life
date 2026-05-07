import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/api_endpoints.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/view_models/goals/goals_state.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../models/dashboard/category.dart';
import '../../../models/goals/goal.dart';

class CategoryGoalItem extends StatefulWidget {
  final Category category;

  const CategoryGoalItem({required this.category, super.key});

  @override
  State<CategoryGoalItem> createState() => _CategoryGoalItemState();
}

class _CategoryGoalItemState extends State<CategoryGoalItem> {
  @override
  Widget build(BuildContext context) {
    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.network(
                    "${ApiEndpoints.serverUrl}${widget.category.iconUrl}"),
                SizedBox(
                  width: Spacing.normal,
                ),
                CustomText(
                  text: widget.category.title,
                  weight: FontWeight.w600,
                  size: AppConstants.font16Px,
                )
              ],
            ),
            if (widget.category.goals.isEmpty)
              addNewGoal()
            else
              progressIndicators(widget.category.goals)
          ],
        ),
      ),
    );
  }

  Widget progressIndicators(List<Goal> goals) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(children: [
        if (goals.isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 28,
                lineWidth: 8,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: ColorConstants.primary,
                percent: (goals[0].completedActions / goals[0].totalActions)
                    .toDouble(),
                center: CustomText(
                  text: goals[0].completedActions == 0 ? "0%" :
                      '${((goals[0].completedActions / goals[0].totalActions)*100).toInt()}%',
                  weight: FontWeight.w800,
                  size: AppConstants.font12Px,
                ),
                backgroundColor: ColorConstants.primary.withOpacity(0.1),
              ),
              SizedBox(
                height: Spacing.small,
              ),
              CustomText(
                text: "Goal 1",
                overflow: TextOverflow.ellipsis,
                weight: FontWeight.w800,
                size: AppConstants.font12Px,
              )
            ],
          ),
        if (goals.length == 2) ...[
          SizedBox(
            width: Spacing.standard,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 28,
                lineWidth: 8,
                progressColor: ColorConstants.primary,
                circularStrokeCap: CircularStrokeCap.round,
                percent: (goals[1].completedActions / goals[1].totalActions)
                    .toDouble(),
                center: CustomText(
                  text: goals[1].completedActions == 0 ? "0%" :
                  '${((goals[1].completedActions / goals[1].totalActions)*100).toInt()}%',
                  weight: FontWeight.w800,
                  size: AppConstants.font12Px,
                ),
                backgroundColor: ColorConstants.primary.withOpacity(0.1),
              ),
              SizedBox(
                height: Spacing.small,
              ),
              CustomText(
                text: "Goal 2",
                weight: FontWeight.w800,
                size: AppConstants.font12Px,
              )
            ],
          ),
        ],
      ]),
    );
  }

  Widget addNewGoal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: AppConstants.addANewGoal,
          textColor: ColorConstants.blackInputText.withOpacity(0.5),
          weight: FontWeight.w500,
          size: AppConstants.font14Px,
          align: TextAlign.center,
        ),
        SizedBox(width: Spacing.small,),
        Padding(
          padding: const EdgeInsets.only(top: Spacing.regular, right: 0),
          child: SvgPicture.asset(AppIcons.moveForward, alignment: Alignment.center, width: 48.w, height: 48.h, fit: BoxFit.fill,),
        )
      ],
    );
  }
}
