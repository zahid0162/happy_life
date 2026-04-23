import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';
import 'package:my_happy_work_place/constants/app_routes.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/utils/injectors.dart';
import 'package:my_happy_work_place/utils/utils.dart';
import 'package:my_happy_work_place/view_models/action/_action_event.dart';
import 'package:my_happy_work_place/view_models/action/action_view_model.dart';
import 'package:my_happy_work_place/views/pages/actions_views/action_progress_item.dart';
import 'package:my_happy_work_place/views/pages/actions_views/empty_action_view.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';

import '../../../utils/app_loader.dart';
import '../../../view_models/action/action_state.dart';
import '../bottom_sheet/date_bottom_picker.dart';

class MainActionsScreen extends StatefulWidget {
  const MainActionsScreen({super.key});

  @override
  State<MainActionsScreen> createState() => _MainActionsScreenState();
}

class _MainActionsScreenState extends State<MainActionsScreen> {
  void _updateDate(int days, ActionState state) {
    getIt<ActionsViewModel>().add(
        OnDateChanged(newDate: state.currentDate.add(Duration(days: days)), onError: ({required String error}) {}, onSuccess: ({required String message}) {}));
    _getActionsList();
  }

  void _updateCustomDate(DateTime date) {
    getIt<ActionsViewModel>().add(OnDateChanged(newDate: date,onError: ({required String error}) {}, onSuccess: ({required String message}) {}));
    _getActionsList();
  }

  @override
  void initState() {
    super.initState();
  }

  void _getActionsList() {
    final loaderCubit = context.read<LoaderCubit>();
    loaderCubit.showLoader();
    getIt<ActionsViewModel>()
        .add(GetActionsByDateEvent(onError: ({required String error}) {
      loaderCubit.hideLoader();
      Utils.showSnackBar(message: error, context: context);
    }, onSuccess: ({required String message}) {
      loaderCubit.hideLoader();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<ActionsViewModel, ActionState>(
          builder: (context, actionState) {
        return FloatingActionButton(
          backgroundColor: ColorConstants.primary,
          onPressed: () {
            actionState.selectedCategory = null;
            actionState.selectedGoal = null;
            AppRouter.pushNamed(
                context: context, route: AppRoutes.createAction);
          },
          child: SvgPicture.asset(
            AppIcons.add,
            color: ColorConstants.homeScreenBackground,
          ),
        );
      }),
      body: BlocBuilder<ActionsViewModel, ActionState>(
          builder: (context, actionState) {
        return SafeArea(
          child: Stack(
            children: [
              // Scrollable content
              if (actionState.actions.isNotEmpty)
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: Spacing.standard + 80.h,
                      // Height of the date header + spacing
                      left: Spacing.standard,
                      right: Spacing.standard,
                      bottom: 90.h),
                  child: Column(
                    children: [
                      ListView.separated(
                        controller: ScrollController(),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ActionProgressItem(
                            isToday: _isToday(actionState.currentDate),
                            action: actionState.actions[index],
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: Spacing.medium,
                        ),
                        itemCount: actionState.actions.length,
                      )
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.standard),
                  child: EmptyActionsView(),
                ),
              // Sticky date header
              Positioned(
                top: 0,
                left: Spacing.standard,
                right: Spacing.standard,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null) {
                      if (details.primaryVelocity! < 0) {
                        // Swiped left (Next day)
                        _updateDate(1, actionState);
                      } else if (details.primaryVelocity! > 0) {
                        // Swiped right (Previous day)
                        _updateDate(-1, actionState);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Spacing.xlarge, vertical: Spacing.small),
                    decoration: BoxDecoration(
                      color: ColorConstants.genderUnselectedBgColor,
                      borderRadius:
                          BorderRadius.circular(AppConstants.defaultRadius + 4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _updateDate(-1, actionState),
                          child: SvgPicture.asset(AppIcons.arrowLeft),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDateBottomSheet(actionState);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: AppConstants.defaultIconSize,
                              ),
                              SizedBox(
                                width: Spacing.normal,
                              ),
                              CustomText(
                                text: _getDisplayDate(actionState.currentDate),
                                weight: FontWeight.w500,
                                size: AppConstants.font14Px,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _updateDate(1, actionState),
                          child: SvgPicture.asset(AppIcons.arrowRight),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _getDisplayDate(DateTime _currentDate) {
    final today = DateTime.now();
    final formattedDate =
        DateFormat(AppConstants.displayDateFormat).format(_currentDate);

    if (_currentDate.year == today.year &&
        _currentDate.month == today.month &&
        _currentDate.day == today.day) {
      return '${AppConstants.today}, $formattedDate';
    }
    return formattedDate;
  }

  bool _isToday(DateTime _currentDate) {
    final today = DateTime.now();

    return _currentDate.year == today.year &&
        _currentDate.month == today.month &&
        _currentDate.day == today.day;
  }

  Future<void> _showDateBottomSheet(ActionState state) async {
    DateTime? result = await showModalBottomSheet(
      backgroundColor: ColorConstants.homeScreenBackground,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DatePickerSheet(
          title: AppConstants.selectDate,
          selectedDate: state.currentDate,
          firstDay: DateTime(2000, 1, 1),
          lastDay: DateTime(3000, 1, 1),
        );
      },
    );
    if (result != null) {
      _updateCustomDate(result);
    }
  }
}
