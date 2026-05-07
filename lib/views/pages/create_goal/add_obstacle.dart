import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/app_routes.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/models/enum/difficulty_level.dart';
import 'package:my_happy_work_place/models/goals/goal_detail.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/view_models/goals/goal_view_model.dart';
import 'package:my_happy_work_place/view_models/goals/goals_state.dart';
import 'package:my_happy_work_place/views/pages/bottom_sheet/select_difficulty_level.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddObstacleView extends StatefulWidget {
  const AddObstacleView({super.key});

  @override
  State<AddObstacleView> createState() => _AddObstacleViewState();
}

class _AddObstacleViewState extends State<AddObstacleView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _obstacleController = TextEditingController();
  final _difficultyController = TextEditingController();
  bool isValidObstacle = true;
  bool isValidDifficulty = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      floatingActionButton: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: 0.33,
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
                title: AppConstants.continueNext,
                onTap: () {
                  if(_formKey.currentState!.validate()) {
                    AppRouter.pushNamed(context: context, route: AppRoutes.addActions);
                  }
                },
                textSize: AppConstants.font16Px,
                weight: FontWeight.w600,
                radius: AppConstants.defaultButtonRadius,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<GoalsViewModel, GoalsState>(
            builder: (context, goalsState) {
          _difficultyController.text =
              goalsState.createGoalDetail.obstacles[0].difficulty;
          _obstacleController.text =
              goalsState.createGoalDetail.obstacles[0].obstacle;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.standard),
            child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: Spacing.standard),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: "${AppConstants.step} 2/3",
                          weight: FontWeight.w500,
                          size: AppConstants.font12Px,
                          textColor: ColorConstants.lightTextColor),
                      SizedBox(
                        height: Spacing.regular,
                      ),
                      CustomText(

                        text: AppConstants.addObstacle,
                        weight: FontWeight.w500,
                        size: AppConstants.font16Px,
                      ),
                      _inputFields(goalsState)
                    ],
                  ))

          );
        }),
      ),
    );
  }

  Widget _inputFields(GoalsState goalState) {
    return Container(
      margin: const EdgeInsets.only(top: Spacing.xxxlarge + Spacing.xxlarge),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            StatefulBuilder(builder: (context, state) {
              return Container(
                  padding: EdgeInsets.only(
                      bottom: isValidObstacle ? Spacing.zero : Spacing.regular),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: CustomTextField(
                    label: AppConstants.obstacle,
                    contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                    errorHeight: 0.6,
                    onValidate: (String? text) {
                      if (text == null || text.isEmpty || text.trim().isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          isValidObstacle = false;
                          state(() {});
                        });
                        return AppConstants.fieldRequired;
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidObstacle = true;
                        state(() {});
                      });

                      return null;
                    },
                    onChange: (text) {
                      goalState.createGoalDetail.obstacles[0].obstacle = text.trim();
                    },
                    borderSide:
                        BorderSide(color: ColorConstants.borderColor, width: 1),
                    hint: AppConstants.addObstacle,
                    hintWeight: FontWeight.w500,
                    textEditingController: _obstacleController,
                    filledColor: Colors.white,
                  ));
            }),
            const SizedBox(
              height: Spacing.xxxlarge,
            ),
            StatefulBuilder(builder: (context, state) {
              return Container(
                  padding: EdgeInsets.only(
                      bottom:
                          isValidDifficulty ? Spacing.zero : Spacing.regular),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: CustomTextField(
                    isDisabled: true,
                    onTap: (){
                      _showFrequencyBottomSheet(goalState.createGoalDetail, _difficultyController);
                    },
                    suffixIcon: SvgPicture.asset(
                      AppIcons.dropdownArrow,
                      fit: BoxFit.none,
                    ),
                    label: AppConstants.difficultyLevel,
                    contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                    errorHeight: 0.6,
                    onValidate: (String? text) {
                      if (text == null || text.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          isValidDifficulty = false;
                          state(() {});
                        });
                        return AppConstants.fieldRequired;
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isValidDifficulty = true;
                        state(() {});
                      });

                      return null;
                    },
                    onChange: (text) {
                      goalState.createGoalDetail.obstacles[0].difficulty = text;
                    },
                    borderSide:
                        BorderSide(color: ColorConstants.borderColor, width: 1),
                    hint: AppConstants.difficultyLevelHint,
                    hintWeight: FontWeight.w500,
                    inputType: TextInputType.multiline,
                    textEditingController: _difficultyController,
                    filledColor: Colors.white,
                  ));
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _showFrequencyBottomSheet(
      GoalDetail goalDetail, TextEditingController controller) async {
    DifficultyLevel? result = await showModalBottomSheet(
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
          return SelectDifficultyLevel(
            selectedLevel: DifficultyLevel.getLevelByString(
                goalDetail.obstacles[0].difficulty),
          );
        });
      },
    );
    if (result != null) {
      controller.text = result.name;
      goalDetail.obstacles[0].difficulty = result.name;
    }
  }
}
