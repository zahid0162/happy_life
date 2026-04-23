import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:my_happy_work_place/models/dashboard/action.dart';
import 'package:my_happy_work_place/models/dashboard/category.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/utils/calendar_launcher.dart';
import 'package:my_happy_work_place/utils/date_time_utils.dart';
import 'package:my_happy_work_place/utils/injectors.dart';
import 'package:my_happy_work_place/utils/utils.dart';
import 'package:my_happy_work_place/view_models/action/_action_event.dart';
import 'package:my_happy_work_place/view_models/action/action_state.dart';
import 'package:my_happy_work_place/view_models/action/action_view_model.dart';
import 'package:my_happy_work_place/view_models/goals/goal_view_model.dart';
import 'package:my_happy_work_place/view_models/goals/goals_state.dart';
import 'package:my_happy_work_place/views/pages/bottom_sheet/frequency_selection_sheet.dart';
import 'package:my_happy_work_place/views/pages/bottom_sheet/select_category_sheet.dart';
import 'package:my_happy_work_place/views/pages/bottom_sheet/select_goal_sheet.dart';
import 'package:my_happy_work_place/views/pages/bottom_sheet/time_picker_sheet.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/spacing.dart';
import '../../../models/goals/goal.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/toast_message.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../bottom_sheet/date_bottom_picker.dart';

class CreateNewAction extends StatefulWidget {
  const CreateNewAction({super.key});

  @override
  State<CreateNewAction> createState() => _CreateNewActionState();
}

class _CreateNewActionState extends State<CreateNewAction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _actionCategoryController = TextEditingController();
  final _actionGoalController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _actionTitleController = TextEditingController();
  final _actionFrequencyController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  bool isValidTitle = true;
  bool isValidCategory = true;
  bool isValidGoal = true;
  bool isValidStartDate = true;
  bool isValidEndDate = true;
  bool isValidFrequency = true;
  bool isValidStartTime = true;
  bool isValidEndTime = true;
  String title = AppConstants.addAction;
  DateTime? startDate;
  DateTime? endDate;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  void _getCategories() {
    final loaderCubit = context.read<LoaderCubit>();
    loaderCubit.showLoader();
    getIt<ActionsViewModel>()
        .add(GetCategoriesEvent(onError: ({required String error}) {
      loaderCubit.hideLoader();
      AppRouter.pop(context: context);
      Utils.showSnackBar(message: error, context: context);
    }, onSuccess: ({required String message}) {
      loaderCubit.hideLoader();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          text: AppConstants.addAction,
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
      floatingActionButton: BlocBuilder<ActionsViewModel, ActionState>(
          builder: (context, actionState) {
        return Padding(
          padding: const EdgeInsets.only(
              left: Spacing.standard,
              right: Spacing.standard,
              top: Spacing.xxlarge),
          child: CustomButton(
            title: AppConstants.saveAction,
            onTap: () {
              _createAction(actionState);
            },
            textSize: AppConstants.font16Px,
            weight: FontWeight.w600,
            radius: AppConstants.defaultButtonRadius,
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ActionsViewModel, ActionState>(
            builder: (context, actionState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.standard),
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: Spacing.standard, bottom: Spacing.xxxxlarge * 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_inputFields(actionState)],
                )),
          );
        }),
      ),
    );
  }

  Widget _inputFields(ActionState actionState) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          StatefulBuilder(builder: (context, state) {
            return Container(
                padding: EdgeInsets.only(bottom: Spacing.zero),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: CustomTextField(
                  label: AppConstants.category,
                  contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                  errorHeight: 0.6,
                  isDisabled: true,
                  onTap: () {
                    _showCategorySelectionSheet(actionState);
                  },
                  onValidate: (String? text) {
                    if (text == null || text.isEmpty || text.trim().isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidCategory = false;
                        state(() {});
                      });
                      return AppConstants.fieldRequired;
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      isValidCategory = true;
                      state(() {});
                    });

                    return null;
                  },
                  suffixIcon: SvgPicture.asset(
                    AppIcons.dropdownArrow,
                    fit: BoxFit.none,
                  ),
                  autovalidateMode: autovalidateMode,
                  borderSide:
                      BorderSide(color: ColorConstants.borderColor, width: 1),
                  hint: AppConstants.exampleHealth,
                  hintWeight: FontWeight.w500,
                  textEditingController: _actionCategoryController,
                  filledColor: Colors.white,
                ));
          }),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
          StatefulBuilder(builder: (context, state) {
            return Container(
                padding: EdgeInsets.only(bottom: Spacing.zero),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: CustomTextField(
                  label: AppConstants.goal,
                  contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                  errorHeight: 0.6,
                  isDisabled: true,
                  autovalidateMode: autovalidateMode,
                  onTap: () {
                    if (actionState.selectedCategory == null) {
                      Utils.showSnackBar(
                          message: "Please select category first.",
                          context: context);
                      return;
                    }
                    _showGoalSelectionSheet(actionState);
                  },
                  onValidate: (String? text) {
                    if (text == null || text.isEmpty || text.trim().isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidGoal = false;
                        state(() {});
                      });
                      return AppConstants.fieldRequired;
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      isValidGoal = true;
                      state(() {});
                    });

                    return null;
                  },
                  suffixIcon: SvgPicture.asset(
                    AppIcons.dropdownArrow,
                    fit: BoxFit.none,
                  ),
                  borderSide:
                      BorderSide(color: ColorConstants.borderColor, width: 1),
                  hint: AppConstants.exampleHealth,
                  hintWeight: FontWeight.w500,
                  textEditingController: _actionGoalController,
                  filledColor: Colors.white,
                ));
          }),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
          StatefulBuilder(builder: (context, state) {
            return Container(
                padding: EdgeInsets.only(
                    bottom: isValidTitle ? Spacing.zero : Spacing.regular),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: CustomTextField(
                  label: AppConstants.actionTitle,
                  contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                  errorHeight: 0.6,
                  autovalidateMode: autovalidateMode,
                  onValidate: (String? text) {
                    if (text == null || text.isEmpty || text.trim().isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidTitle = false;
                        state(() {});
                      });
                      return AppConstants.fieldRequired;
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      isValidTitle = true;
                      state(() {});
                    });

                    return null;
                  },
                  borderSide:
                      BorderSide(color: ColorConstants.borderColor, width: 1),
                  hint: AppConstants.setActionTitle,
                  hintWeight: FontWeight.w500,
                  textEditingController: _actionTitleController,
                  filledColor: Colors.white,
                ));
          }),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
          StatefulBuilder(builder: (context, state) {
            return Container(
                padding: EdgeInsets.only(
                    bottom: isValidFrequency ? Spacing.zero : Spacing.regular),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: CustomTextField(
                  label: AppConstants.frequency,
                  contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                  errorHeight: 0.6,
                  onValidate: (String? text) {
                    if (text == null || text.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidFrequency = false;
                        state(() {});
                      });
                      return AppConstants.fieldRequired;
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      isValidFrequency = true;
                      state(() {});
                    });

                    return null;
                  },
                  autovalidateMode: autovalidateMode,
                  isDisabled: true,
                  onTap: () {
                    _showFrequencyBottomSheet();
                  },
                  borderSide:
                      BorderSide(color: ColorConstants.borderColor, width: 1),
                  hint: AppConstants.setFreqHint,
                  hintWeight: FontWeight.w500,
                  textEditingController: _actionFrequencyController,
                  filledColor: Colors.white,
                ));
          }),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
          StatefulBuilder(builder: (context, state) {
            return Container(
                padding: EdgeInsets.only(
                    bottom: isValidStartDate ? Spacing.zero : Spacing.regular),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: CustomTextField(
                    onTap: () {
                      if (actionState.selectedGoal == null) {
                        Utils.showSnackBar(
                            message: "Please select goal first.",
                            context: context);
                        return;
                      }
                      _showDateBottomSheet(_startDateController, true);
                    },
                    autovalidateMode: autovalidateMode,
                    isDisabled: true,
                    label: AppConstants.startingDate,
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: ColorConstants.blackInputText,
                      size: AppConstants.defaultIconSize,
                    ),
                    contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                    errorHeight: 0.6,
                    onValidate: (text) {
                      if (text == null || text.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          isValidStartDate = false;
                          state(() {});
                        });
                        return AppConstants.fieldRequired;
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidStartDate = true;
                        state(() {});
                      });
                      return null;
                    },
                    borderSide: null,
                    hint: AppConstants.setStartDate,
                    hintWeight: FontWeight.w500,
                    textEditingController: _startDateController,
                    filledColor: Colors.white));
          }),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
          StatefulBuilder(builder: (context, state) {
            return Container(
                padding: EdgeInsets.only(
                    bottom: isValidEndDate ? Spacing.zero : Spacing.regular),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: CustomTextField(
                    onTap: () {
                      if (actionState.selectedGoal == null) {
                        Utils.showSnackBar(
                            message: "Please select goal first.",
                            context: context);
                        return;
                      }
                      _showDateBottomSheet(_endDateController, false);
                    },
                    isDisabled: true,
                    label: AppConstants.estimatedEndDate,
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: ColorConstants.blackInputText,
                      size: AppConstants.defaultIconSize,
                    ),
                    autovalidateMode: autovalidateMode,
                    contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                    errorHeight: 0.6,
                    onValidate: (text) {
                      if (text == null || text.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          isValidEndDate = false;
                          state(() {});
                        });
                        return AppConstants.fieldRequired;
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidEndDate = true;
                        state(() {});
                      });
                      return null;
                    },
                    borderSide: null,
                    hint: AppConstants.setEstimatedEndDate,
                    hintWeight: FontWeight.w500,
                    textEditingController: _endDateController,
                    filledColor: Colors.white));
          }),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: AppConstants.defaultIconSize - 8,
              ),
              SizedBox(
                width: Spacing.small,
              ),
              GestureDetector(
                onTap: () async {
                  if (actionState.isCalendarConnected == false) {
                    getIt<ActionsViewModel>()
                        .add(ConnectCalendarEvent(onSuccess: ({required String message}) {
                      Utils.showSnackBar(
                          message: AppConstants.calendarConnectedSuccessfully,
                          context: context);
                    }, onError: ({required String error}) {
                      Utils.showSnackBar(message: error, context: context);
                    }));
                  } else {
                    await UrlLauncher.openCalendar();
                  }
                },
                child: CustomText(
                  text: actionState.isCalendarConnected == true
                      ? AppConstants.viewCalendar
                      : AppConstants.connectCalendar,
                  textColor: ColorConstants.primary,
                  weight: FontWeight.w500,
                  size: AppConstants.font14Px,
                ),
              ),
              SizedBox(
                width: Spacing.small,
              ),
              CustomText(
                text: AppConstants.avoidOverlapping,
                textColor: ColorConstants.textLabelColor,
                weight: FontWeight.w400,
                size: AppConstants.font14Px,
              ),
            ],
          ),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatefulBuilder(builder: (context, state) {
                return Container(
                    width: 0.45.sw,
                    padding: EdgeInsets.only(
                        bottom:
                            isValidStartTime ? Spacing.zero : Spacing.regular),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: CustomTextField(
                        onTap: () {
                          _showTimeBottomSheet(
                              _startTimeController,
                              AppConstants.selectStartTime,
                              DateTimeUtils.dateTimeFromTimeString(
                                  _startTimeController.text));
                        },
                        isDisabled: true,
                        autovalidateMode: autovalidateMode,
                        label: AppConstants.startTime,
                        suffixIcon: SvgPicture.asset(AppIcons.clockIcon),
                        contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                        errorHeight: 0.6,
                        onValidate: (text) {
                          if (text == null || text.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              isValidStartTime = false;
                              state(() {});
                            });
                            return AppConstants.fieldRequired;
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            isValidStartTime = true;
                            state(() {});
                          });
                          return null;
                        },
                        borderSide: null,
                        hint: AppConstants.selectStartTime,
                        hintWeight: FontWeight.w500,
                        textEditingController: _startTimeController,
                        filledColor: Colors.white));
              }),
              StatefulBuilder(builder: (context, state) {
                return Container(
                    width: 0.45.sw,
                    padding: EdgeInsets.only(
                        bottom:
                            isValidEndTime ? Spacing.zero : Spacing.regular),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: CustomTextField(
                        onTap: () {
                          _showTimeBottomSheet(
                              _endTimeController,
                              AppConstants.selectEndTime,
                              DateTimeUtils.dateTimeFromTimeString(
                                  _endTimeController.text));
                        },
                        isDisabled: true,
                        label: AppConstants.endTime,
                        suffixIcon: SvgPicture.asset(AppIcons.clockIcon, ),
                        contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                        errorHeight: 0.6,
                        onValidate: (text) {
                          if (text == null || text.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              isValidEndTime = false;
                              state(() {});
                            });
                            return AppConstants.fieldRequired;
                          }
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            isValidEndTime = true;
                            state(() {});
                          });
                          return null;
                        },
                        borderSide: null,
                        hint: AppConstants.selectEndTime,
                        hintWeight: FontWeight.w500,
                        textEditingController: _endTimeController,
                        filledColor: Colors.white));
              }),
            ],
          ),
          const SizedBox(
            height: Spacing.xxxlarge,
          ),
        ],
      ),
    );
  }

  Future<void> _showDateBottomSheet(
      TextEditingController controller, bool isStartDate) async {
    DateTime? result = await showModalBottomSheet(
      backgroundColor: ColorConstants.homeScreenBackground,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return BlocBuilder<ActionsViewModel, ActionState>(
            builder: (context, actionState) {
          return DatePickerSheet(
            title: isStartDate
                ? AppConstants.selectStartDate
                : AppConstants.selectEndDate,
            selectedDate: isStartDate
                ? startDate ?? actionState.selectedGoal!.startDate
                : endDate ?? actionState.selectedGoal!.startDate,
            firstDay: actionState.selectedGoal!.startDate,
            lastDay: actionState.selectedGoal!.estimatedEndDate,
          );
        });
      },
    );
    if (result != null) {
      controller.text =
          DateFormat(AppConstants.displayDateFormat).format(result);
      isStartDate ? startDate = result : endDate = result;
    }
  }

  Future<void> _showTimeBottomSheet(TextEditingController controller,
      String title, DateTime currentTime) async {
    DateTime? result = await showModalBottomSheet(
      backgroundColor: ColorConstants.homeScreenBackground,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return BlocBuilder<ActionsViewModel, ActionState>(
            builder: (context, goalState) {
          return TimePickerSheet(
            title: title,
            selectedDate: currentTime,
          );
        });
      },
    );
    if (result != null) {
      controller.text =
          DateFormat(AppConstants.displayTimeFormat).format(result);
    }
  }

  Future<void> _showFrequencyBottomSheet() async {
    String? result = await showModalBottomSheet(
      backgroundColor: ColorConstants.homeScreenBackground,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return BlocBuilder<GoalsViewModel, GoalsState>(
            builder: (context, goalState) {
          return FrequencySelectionSheet(
              lastSelectedFrequency: _actionFrequencyController.text);
        });
      },
    );
    if (result != null) {
      _actionFrequencyController.text = result;
    }
  }

  Future<void> _showCategorySelectionSheet(ActionState actionState) async {
    Category? result = await showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: 0.8.sh),
      backgroundColor: ColorConstants.homeScreenBackground,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SelectCategorySheet(
          selectedCategory: actionState.selectedCategory,
          categories: actionState.categories,
        );
      },
    );
    if (result != null) {
      _actionCategoryController.text = result.title;
      actionState.selectedCategory = result;
      actionState.selectedGoal = null;
      _actionGoalController.text = '';
      _startDateController.text = '';
      _endDateController.text = '';
      startDate = null;
      endDate = null;
    }
  }

  Future<void> _showGoalSelectionSheet(ActionState actionState) async {
    Goal? result = await showModalBottomSheet(
      backgroundColor: ColorConstants.homeScreenBackground,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final index =
            actionState.categories.indexOf(actionState.selectedCategory!);
        return SelectGoalSheet(
            selectedGoal: actionState.selectedGoal,
            goals: actionState.categories[index].goals);
      },
    );
    if (result != null) {
      _actionGoalController.text = result.title;
      actionState.selectedGoal = result;
      _startDateController.text = '';
      _endDateController.text = '';
      startDate = null;
      endDate = null;
    }
  }

  void _createAction(ActionState actionState) {
    autovalidateMode = AutovalidateMode.onUserInteraction;
    if (_formKey.currentState!.validate()) {
      if (!DateTimeUtils.isStartDateLessThanEndDate(
          DateTimeUtils.parseDateFromString(_startDateController.text),
          DateTimeUtils.parseDateFromString(_endDateController.text))) {
        Utils.showSnackBar(
            message: AppConstants.endDateMustBeAfterStartDate,
            context: context);
        return;
      }
      if (!DateTimeUtils.isStartTimeLessThanEndTime(
          DateTimeUtils.dateTimeFromTimeString(_startTimeController.text),
          DateTimeUtils.dateTimeFromTimeString(_endTimeController.text))) {
        Utils.showSnackBar(
            message: AppConstants.endTimeMustBeAfterStartTime,
            context: context);
        return;
      }

      if (!_validateFrequency()) return;

      _saveChanges(actionState);
    }
  }

  void getStringFromDate(DateTime? dateTime, TextEditingController controller) {
    controller.text = dateTime != null
        ? DateFormat(AppConstants.displayDateFormat).format(dateTime)
        : '';
  }

  void _saveChanges(ActionState actionState) {
    final loaderCubit = context.read<LoaderCubit>();
    loaderCubit.showLoader();
    getIt<ActionsViewModel>().add(
      CreateActionEvent(
          action: GoalAction(
              id: '',
              goalId: actionState.selectedGoal!.id,
              category: actionState.selectedCategory!,
              action: _actionTitleController.text.trim(),
              frequency: _actionFrequencyController.text,
              startDate: startDate,
              estimatedEndDate: endDate,
              startTime: _startTimeController.text,
              endTime: _endTimeController.text,
              status: 'active'),
          onSuccess: ({required String message}) {
            getIt<ActionsViewModel>().add(GetActionsByDateEvent(
                onError: ({required String error}) {},
                onSuccess: ({required String message}) {}));
            loaderCubit.hideLoader();
            showToast(context, message);
            AppRouter.pop(context: context);
          },
          onError: ({required String error}) {
            loaderCubit.hideLoader();
            Utils.showSnackBar(message: error, context: context);
          }),
    );
  }

  bool _validateFrequency() {
    final frequency = _actionFrequencyController.text;
    if (frequency == AppConstants.daily) return true;
    List<DateTime> dateRange =
        DateTimeUtils.generateDateRange(startDate!, endDate!);
    List<String> validDays = DateTimeUtils.extractDaysFromRange(dateRange);

    if (frequency == AppConstants.monFri) {
      // Check if weekdays (Mon-Fri) exist in the range
      if (AppConstants.weekDaysList.any((day) => validDays.contains(day))) {
        return true;
      } else {
        Utils.showSnackBar(
            message: AppConstants.freqNotAlignedWithMonFri, context: context);
      }
    } else {
      // Specific days (comma-separated)
      List<String> selectedDaysList =
          frequency.split(",").map((day) => day.trim()).toList();
      if (selectedDaysList.any((day) => validDays.contains(day))) {
        return true;
      } else {
        Utils.showSnackBar(
            message: AppConstants.freqNotAlignedWithDays, context: context);
      }
    }
    return false;
  }

  void showToast(BuildContext context, String message, {Duration duration = const Duration(seconds: 3)}) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Position below the top bar
        left: Spacing.standard,
        right: Spacing.standard,
        child: ToastMessage(message: message),
      ),
    );

    // Insert the overlay entry
    overlayState.insert(overlayEntry);

    // Remove the overlay after the duration
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
