import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';

class ToastMessage extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;

  const ToastMessage({
    super.key,
    required this.message,
    this.backgroundColor = ColorConstants.homeScreenBackground,
    this.duration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(
            top: 50.h, left: Spacing.standard, right: Spacing.standard),
        // Adjust to position below the top bar
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.standard, vertical: Spacing.standard),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius-6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(AppIcons.successToast),
            SizedBox(
              width: Spacing.standard,
            ),
            CustomText(
              text: message,
              weight: FontWeight.w500,
              size: AppConstants.font16Px,
            ),
          ],
        ),
      ),
    );
  }
}
