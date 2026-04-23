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
import 'package:my_happy_work_place/view_models/action/_action_event.dart';
import 'package:my_happy_work_place/view_models/action/action_view_model.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';

import '../../../utils/app_loader.dart';

class ActionProgressItem extends StatefulWidget {
  final ActionProgress action;
  final bool isToday;

  const ActionProgressItem(
      {super.key, required this.action, required this.isToday});

  @override
  State<ActionProgressItem> createState() => _ActionProgressItemState();
}

class _ActionProgressItemState extends State<ActionProgressItem> {
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
                                      "${widget.action.startTime}-${widget.action.endTime} ${widget.action.action.frequency}",
                                  weight: FontWeight.w500,
                                  size: AppConstants.font14Px,
                                ),
                              ),
                              CustomText(
                                text: widget.action.action.estimatedEndDate !=
                                        null
                                    ? "Due: ${DateFormat(AppConstants.displayDateFormat).format(widget.action.action.estimatedEndDate!)}"
                                    : 'N/A',
                                weight: FontWeight.w500,
                                size: AppConstants.font14Px,
                              ),
                            ],
                          ),
                          // Due Date
                          if (widget.action.status.toLowerCase() ==
                                  AppConstants.completedStatus ||
                              widget.action.status.toLowerCase() ==
                                  AppConstants.upcomingStatus)
                            Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                value: widget.action.status.toLowerCase() ==
                                    AppConstants.completedStatus,
                                onChanged: (bool? value) {
                                  if (widget.isToday &&
                                      widget.action.status.toLowerCase() ==
                                          AppConstants.upcomingStatus) {
                                    setState(() {
                                      widget.action.action.isCompletedByUser =
                                          value ?? false;
                                    });
                                    loaderCubit.showLoader();
                                    getIt<ActionsViewModel>()
                                        .add(UpdateActionStatus(
                                      action: widget.action,
                                      onSuccess: ({required String message}) {
                                        loaderCubit.hideLoader();
                                        Utils.showSnackBar(
                                            message: AppConstants
                                                .actionCompletedSuccess,
                                            context: context);
                                      },
                                      onError: ({required String error}) {
                                        loaderCubit.hideLoader();
                                        Utils.showSnackBar(
                                            message: error, context: context);
                                      },
                                    ));
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.defaultRadius - 10),
                                ),
                                side: BorderSide(
                                  color: widget.isToday
                                      ? ColorConstants.blackInputText
                                      : ColorConstants.blackInputText
                                          .withOpacity(0.1),
                                  width: 1,
                                ),
                                activeColor: ColorConstants.primary,
                                checkColor: Colors.white,
                              ),
                            ),
                          if (widget.action.status.toLowerCase() ==
                              AppConstants.overdueStatus)
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: Spacing.medium),
                              child: SvgPicture.asset(AppIcons.actionOverdue),
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
