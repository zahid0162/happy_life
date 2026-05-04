import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_happy_work_place/models/enum/difficulty_level.dart';
import 'package:my_happy_work_place/models/enum/gender_enum.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class SelectDifficultyLevel extends StatefulWidget {
  DifficultyLevel? selectedLevel;

  SelectDifficultyLevel({super.key, this.selectedLevel});

  @override
  State createState() => _SelectDifficultyLevelState();
}

class _SelectDifficultyLevelState extends State<SelectDifficultyLevel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            top: Spacing.normal,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: ColorConstants.bottomSheetIndicator,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(
                height: Spacing.standard,
              ),
              CustomText(
                  text: AppConstants.selectDifficultyLevel,
                  weight: FontWeight.w600,
                  size: AppConstants.font16Px),
              difficultyView(setModalState),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: Spacing.xxlarge, horizontal: Spacing.standard),
                decoration: BoxDecoration(
                  color: ColorConstants.homeScreenBackground,
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.bottomTileColor,
                      spreadRadius: 3, // Spread radius
                      blurRadius: 6, // Blur radius
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: CustomButton(
                  onTap: () {
                    Navigator.pop(context, widget.selectedLevel);
                  },
                  title: AppConstants.done,
                  radius: AppConstants.defaultButtonRadius,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget difficultyView(StateSetter setModalState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxlarge*2, horizontal: Spacing.standard),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          singleDifficulty(DifficultyLevel.LOW,setModalState),
          singleDifficulty(DifficultyLevel.MEDIUM, setModalState),
          singleDifficulty(DifficultyLevel.HIGH, setModalState)
        ],
      ),
    );
  }

  Widget singleDifficulty(DifficultyLevel level,StateSetter setModalState){
    return GestureDetector(
      onTap: (){
        setModalState(() {
          widget.selectedLevel = level;
        });
        setState(() {
          widget.selectedLevel = level;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Spacing.medium, horizontal: Spacing.xxxxlarge+4),
        decoration: BoxDecoration(
            color: widget.selectedLevel == level
                ? ColorConstants.genderSelectedBgColor
                : ColorConstants.genderUnselectedBgColor,
            borderRadius:
            BorderRadius.circular(AppConstants.defaultRadius + 4)),
        child: CustomText(
          text: level.name,
          textColor: widget.selectedLevel == level
              ? ColorConstants.primary
              : ColorConstants.blackInputText,
          align: TextAlign.center,
          weight: FontWeight.w500,
          size: AppConstants.font14Px,
        ),
      ),
    );
  }
}
