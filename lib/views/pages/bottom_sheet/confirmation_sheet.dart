import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';
import 'package:my_happy_work_place/constants/app_routes.dart';
import 'package:my_happy_work_place/models/enum/gender_enum.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/utils/preference_helper.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class ConfirmationSheet extends StatelessWidget {
  final String firstMsg;
  final Function onConfirm;
  final String icon;
  final String confirmText;

  const ConfirmationSheet({
    super.key,
    required this.icon,
    required this.firstMsg,
    required this.onConfirm,
    required this.confirmText,
  });

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
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(icon),
              ),
              SizedBox(
                height: Spacing.standard,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xxxlarge * 1.5),
                child: CustomText(
                  text: firstMsg,
                  weight: FontWeight.w800,
                  size: AppConstants.font25Px,
                  align: TextAlign.center,
                  textColor: ColorConstants.darkText,
                ),
              ),
              SizedBox(height: Spacing.xxlarge,),
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
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                        title: confirmText,
                        radius: AppConstants.defaultButtonRadius,
                        backgroundColor: ColorConstants.primary,
                        textColor: ColorConstants.homeScreenBackground,
                      ),
                    ),
                    SizedBox(width: Spacing.standard,),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        title: AppConstants.cancel,
                        radius: AppConstants.defaultButtonRadius,
                        backgroundColor: ColorConstants.buttonSecondary,
                        textColor: ColorConstants.darkText,
                      ),
                    ),
                  ],
                ),

              ),

            ],
          ),
        );
      },
    );
  }
}
