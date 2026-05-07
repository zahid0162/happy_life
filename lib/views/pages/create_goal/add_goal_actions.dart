import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/app_routes.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/utils/utils.dart';
import 'package:my_happy_work_place/view_models/goals/goal_view_model.dart';
import 'package:my_happy_work_place/view_models/goals/goals_events.dart';
import 'package:my_happy_work_place/view_models/goals/goals_state.dart';
import 'package:my_happy_work_place/views/pages/create_goal/add_action_button.dart';
import 'package:my_happy_work_place/views/pages/home_screen/goal_action_item.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/spacing.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/injectors.dart';
import '../../../utils/toast_message.dart';
import '../../widgets/custom_button.dart';

class AddGoalActions extends StatefulWidget {
  const AddGoalActions({super.key});

  @override
  State<AddGoalActions> createState() => _AddGoalActionsState();
}

class _AddGoalActionsState extends State<AddGoalActions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          text: AppConstants.createGoal,
          weight: FontWeight.w600,
          size: AppConstants.font18Px,
          textColor: ColorConstants.darkText,
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(AppIcons.arrowBack)),
        backgroundColor: ColorConstants.homeScreenBackground,
        elevation: 0,
      ),
      floatingActionButton: Container(
          color: ColorConstants.homeScreenBackground,
          child: BlocBuilder<GoalsViewModel, GoalsState>(
              builder: (context, goalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 4,
                  child: LinearProgressIndicator(
                    value: goalState.createGoalDetail.actions.active.isEmpty
                        ? 0.67
                        : 1,
                    valueColor: AlwaysStoppedAnimation(ColorConstants.primary),
                    backgroundColor: ColorConstants.linearProgressBg,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: Spacing.standard,
                      right: Spacing.standard,
                      top: Spacing.xxlarge),
                  child: CustomButton(
                    title: AppConstants.saveGoal,
                    onTap: () {
                      if (goalState
                          .createGoalDetail.actions.active.isNotEmpty) {
                        _createGoal();
                      } else {
                        Utils.showSnackBar(
                            message:
                                AppConstants.goalSaveError,
                            context: context);
                      }
                    },
                    backgroundColor:
                        goalState.createGoalDetail.actions.active.isEmpty
                            ? ColorConstants.primary.withOpacity(0.4)
                            : ColorConstants.primary,
                    textSize: AppConstants.font16Px,
                    weight: FontWeight.w600,
                    radius: AppConstants.defaultButtonRadius,
                  ),
                )
              ],
            );
          })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<GoalsViewModel, GoalsState>(
            builder: (context, goalsState) {
          return Padding(
              padding: const EdgeInsets.only(
                  left: Spacing.standard, right: Spacing.standard, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: "${AppConstants.step} 3/3",
                      weight: FontWeight.w500,
                      size: AppConstants.font12Px,
                      textColor: ColorConstants.lightTextColor),
                  SizedBox(
                    height: Spacing.regular,
                  ),
                  CustomText(
                    text: AppConstants.addActions,
                    weight: FontWeight.w500,
                    size: AppConstants.font16Px,
                  ),
                  GestureDetector(
                      onTap: () {
                        goalsState.currentActionIndex = -1;
                        AppRouter.pushNamed(
                            context: context,
                            route: AppRoutes.createGoalAction);
                      },
                      child: AddActionButton()),

                  Expanded(
                    child: ListView.separated(
                        controller: ScrollController(),
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CreateGoalActionItem(
                            action: goalsState
                                .createGoalDetail.actions.active[index],
                            onDelete: () {
                              getIt<GoalsViewModel>()
                                  .add(RemoveAction(index: index));
                            },
                            onEdit: () {
                              goalsState.currentActionIndex = index;
                              AppRouter.pushNamed(
                                  context: context,
                                  route: AppRoutes.createGoalAction);
                            },
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: Spacing.medium,
                            ),
                        itemCount: goalsState
                            .createGoalDetail.actions.active.length),
                  ),
                ],
              ));
        }),
      ),
    );
  }

  void _createGoal() {
    final loaderCubit = context.read<LoaderCubit>();
    loaderCubit.showLoader();
    getIt<GoalsViewModel>().add(CreateGoalEvent(
      onSuccess: ({required String message}) {
        loaderCubit.hideLoader();
        showToast(context, message);
        AppRouter.popUntil(
            context: context, route: AppRoutes.categoryGoalDetails);
      },
      onError: ({required String error}) {
        loaderCubit.hideLoader();
        Utils.showSnackBar(message: error, context: context);
      },
    ));
  }

  void showToast(BuildContext context, String message, {Duration duration = const Duration(seconds: 3)}) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: Spacing.standard,
        right: Spacing.standard,
        child: ToastMessage(message: message),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
