import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_text.dart';

class EmptyActionsView extends StatelessWidget {


  const EmptyActionsView({super.key, });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.standard),
      child: SizedBox(
        width: double.infinity,
        height: 0.7.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Spacing.xxxxlarge *10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.normal),
              child: DottedBorder(
                padding: EdgeInsets.zero,
                radius: Radius.circular(12),
                color: ColorConstants.primary,
                borderType: BorderType.RRect,
                strokeWidth: 1,
                dashPattern: [10],
                child: Container(
                  height: 104.h,
                  decoration: BoxDecoration(
                    color: ColorConstants.categoryBackground,
                    // Light blue shade
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xxlarge * 2),
                      child: CustomText(
                        text: AppConstants.noActionsYet,
                        weight: FontWeight.w500,
                        size: AppConstants.font14Px,
                        textColor: ColorConstants.blackInputText,
                        maxLines: 3,
                        align: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Spacing.xxlarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: Spacing.xxxlarge*2),
                  child: SvgPicture.asset(AppIcons.addActionArrow),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
