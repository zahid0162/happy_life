import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_happy_work_place/models/enum/gender_enum.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class SelectGenderSheet extends StatefulWidget {
  Gender? selectedGender;

  SelectGenderSheet({super.key, this.selectedGender});

  @override
  State createState() => _CountrySelectorBottomSheetState();
}

class _CountrySelectorBottomSheetState extends State<SelectGenderSheet> {
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
                  text: AppConstants.selectGender,
                  weight: FontWeight.w600,
                  size: AppConstants.font16Px),
              gendersView(setModalState),
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
                    Navigator.pop(context, widget.selectedGender);
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

  Widget gendersView(StateSetter setModalState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxlarge*2, horizontal: Spacing.standard),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          singleGender(Gender.Male,setModalState),
          singleGender(Gender.Female, setModalState),
          singleGender(Gender.Other, setModalState)
        ],
      ),
    );
  }

  Widget singleGender(Gender gender,StateSetter setModalState){
    return GestureDetector(
      onTap: (){
        setModalState(() {
          widget.selectedGender = gender;
        });
        setState(() {
          widget.selectedGender = gender;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Spacing.medium, horizontal: Spacing.xxxxlarge+4),
        decoration: BoxDecoration(
            color: widget.selectedGender == gender
                ? ColorConstants.genderSelectedBgColor
                : ColorConstants.genderUnselectedBgColor,
            borderRadius:
            BorderRadius.circular(AppConstants.defaultRadius + 4)),
        child: CustomText(
          text: gender.name,
          textColor: widget.selectedGender == gender
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
