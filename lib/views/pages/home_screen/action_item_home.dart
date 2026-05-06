import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/models/goals/action_progress.dart';
import 'package:my_happy_work_place/utils/injectors.dart';
import 'package:my_happy_work_place/utils/utils.dart';
import 'package:my_happy_work_place/view_models/user_home/home_events.dart';
import 'package:my_happy_work_place/view_models/user_home/home_viewmodel.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';
import 'package:my_happy_work_place/models/dashboard/action.dart';

import '../../../utils/app_loader.dart';

class HomeActionItem extends StatefulWidget {
  final ActionProgress action;

  const HomeActionItem({super.key, required this.action});

  @override
  State<HomeActionItem> createState() => _HomeActionItemState();
}

class _HomeActionItemState extends State<HomeActionItem> {
  @override
  Widget build(BuildContext context) {
    final loaderCubit = context.read<LoaderCubit>();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      elevation: 0.5,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: Spacing.standard,
                top: Spacing.standard,
                bottom: Spacing.standard,
                right: Spacing.normal),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left content: Task Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Task Title
                      SizedBox(
                        width: 0.6.sw,
                        child: CustomText(
                          text: widget.action.action.action,
                          weight: FontWeight.w600,
                          size: AppConstants.font16Px,
                        ),
                      ),
                      SizedBox(height: Spacing.small),
                      // Task schedule and due date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 0.6.sw,
                            child: CustomText(
                              text:
                                  "${widget.action.startTime}-${widget.action.endTime}, ${widget.action.action.frequency}",
                              weight: FontWeight.w500,
                              size: AppConstants.font14Px,
                            ),
                          ),
                          CustomText(
                            text: widget.action.action.estimatedEndDate != null ?
                            "Due: ${DateFormat(AppConstants.displayDateFormat).format(widget.action.action.estimatedEndDate!)}" : 'N/A',
                            weight: FontWeight.w500,
                            size: AppConstants.font14Px,
                          ),
                        ],
                      ),
                      // Due Date
                  
                  
                          Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              value: widget.action.action.isCompletedByUser,
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.action.action.isCompletedByUser =
                                      value ?? false;
                                });
                                loaderCubit.showLoader();
                                getIt<HomeViewModel>().add(CompleteActionEvent(
                                  action: widget.action,
                                  onSuccess: ({required String message}) {
                                    loaderCubit.hideLoader();
                                    Utils.showSnackBar(
                                        message: AppConstants.actionCompletedSuccess, context: context);
                                  },
                                  onError: ({required String error}) {
                                    loaderCubit.hideLoader();
                                    Utils.showSnackBar(
                                        message: error, context: context);
                                  },
                                ));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.defaultRadius - 10),
                              ),
                              side: const BorderSide(
                                color: ColorConstants.blackInputText,
                                width: 1,
                              ),
                              activeColor: ColorConstants.primary,
                              checkColor: Colors.white,
                            ),
                          ),
                        ],
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
                  color: widget.action.action.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppConstants.defaultRadius))),
              child: CustomText(
                text: widget.action.action.category.title,
                weight: FontWeight.w500,
                size: AppConstants.font12Px,
                textColor: widget.action.action.category.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoalActionItem extends StatefulWidget {
  final GoalAction action;
  final bool showEditIcon;
  final Function onEdit;

  const GoalActionItem(
      {super.key,
      required this.action,
      required this.showEditIcon,
      required this.onEdit});

  @override
  State<GoalActionItem> createState() => _GoalActionItemState();
}

class _GoalActionItemState extends State<GoalActionItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConstants.disBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      elevation: 0,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 0.6.sw,
                                child: CustomText(
                                  text:
                                      "${widget.action.startTime}-${widget.action.endTime} ${widget.action.frequency}",
                                  weight: FontWeight.w500,
                                  size: AppConstants.font14Px,
                                ),
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
                          if (widget.showEditIcon)
                            GestureDetector(
                                onTap: () {
                                  widget.onEdit();
                                },
                                child: SvgPicture.asset(AppIcons.editInfo)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
