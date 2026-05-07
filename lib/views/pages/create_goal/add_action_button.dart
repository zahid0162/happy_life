import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_text.dart';

class AddActionButton extends StatelessWidget {


  const AddActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.standard),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Spacing.xxlarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.large),
              child: DottedBorder(
                padding: EdgeInsets.zero,
                radius: Radius.circular(12),
                color: ColorConstants.primary,
                borderType: BorderType.RRect,
                strokeWidth: 2,
                dashPattern: [10],
                child: Container(
                  height: 86.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorConstants.homeScreenBackground,
                    // Light blue shade
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Spacing.xxsmall,),
                      SvgPicture.asset(AppIcons.addAction),
                      SizedBox(height: Spacing.regular,),
                      CustomText(
                        text: AppConstants.addNewAction,
                        weight: FontWeight.w500,
                        size: AppConstants.font14Px,
                        textColor: ColorConstants.blackInputText,
                        maxLines: 3,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
