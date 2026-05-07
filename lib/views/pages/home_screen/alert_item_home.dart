import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/models/goals/action_progress.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';

import '../../../models/dashboard/action.dart';

class HomeAlertItem extends StatefulWidget {
  final GoalAction action;

  const HomeAlertItem({super.key, required this.action});

  @override
  State<HomeAlertItem> createState() => _HomeAlertItemState();
}

class _HomeAlertItemState extends State<HomeAlertItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      elevation: 0.5,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left content: Task Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Title
                      SizedBox(
                        width: 0.6.sw,
                        child: CustomText(
                          text: widget.action.action,
                          weight: FontWeight.w600,
                          size: AppConstants.font16Px,
                        ),
                      ),
                      SizedBox(height: Spacing.normal),
                      // Task schedule and due date
                      // Due Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    "${widget.action.startTime}-${widget.action.endTime} ${widget.action.frequency}",
                                weight: FontWeight.w500,
                                size: AppConstants.font14Px,
                              ),
                              CustomText(
                                text: widget.action.estimatedEndDate != null
                                    ? "Due: ${DateFormat(AppConstants.displayDateFormat).format(widget.action.estimatedEndDate!)}"
                                    : 'N/A',
                                weight: FontWeight.w500,
                                size: AppConstants.font14Px,
                              ),
                            ],
                          ),
                          SvgPicture.asset(AppIcons.moveForward),
                        ],
                      ),
                      SizedBox(
                        height: Spacing.small,
                      ),
                      Container(
                        padding: EdgeInsets.all(Spacing.small),
                        decoration: BoxDecoration(
                            color:
                                ColorConstants.errorColorHome.withOpacity(0.1),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(
                                AppConstants.defaultRadius - 6)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              AppIcons.error,
                            ),
                            SizedBox(
                              width: Spacing.xsmall,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  CustomText(
                                    maxLines: 2,
                                    text: AppConstants.actionDueDateError,
                                    textColor: ColorConstants.errorColorHome,
                                    align: TextAlign.start,
                                    weight: FontWeight.w400,
                                    size: AppConstants.font12Px,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Top-right text
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Spacing.xxlarge, vertical: Spacing.small),
              decoration: BoxDecoration(
                  color: widget.action.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppConstants.defaultRadius))),
              child: CustomText(
                text: widget.action.category.title,
                weight: FontWeight.w500,
                size: AppConstants.font12Px,
                textColor: widget.action.category.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
