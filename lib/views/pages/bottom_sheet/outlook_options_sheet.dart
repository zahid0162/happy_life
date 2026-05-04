import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../../models/goals/goal.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class OutlookOptionsSheet extends StatefulWidget {
  final Function onChange;
  final Function onDisconnect;

  OutlookOptionsSheet(
      {super.key, required this.onChange, required this.onDisconnect});

  @override
  State createState() => _OutlookOptionsSheetState();
}

class _OutlookOptionsSheetState extends State<OutlookOptionsSheet> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: ColorConstants.homeScreenBackground,
                      borderRadius:
                          BorderRadius.circular(AppConstants.defaultRadius)),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Indicator
                      SizedBox(
                        height: Spacing.standard,
                      ),
                      Container(
                        width: 52.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: ColorConstants.bottomSheetIndicator,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Spacing.xxlarge,
                ),
                _tileOption('Change Email', AppIcons.changeEmail, () {
                  widget.onChange();
                }),
                SizedBox(
                  height: Spacing.xxxlarge,
                ),
                _tileOption('Disconnect Account', AppIcons.disconnectAccount,
                    () {
                  widget.onDisconnect();
                }),
                SizedBox(height: Spacing.xxxlarge*5,)
                // Cities List
                // Padding for floating button
              ],
            ),
            // Floating Done Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                    Navigator.pop(context);
                  },
                  title: AppConstants.cancel,
                  radius: AppConstants.defaultButtonRadius,
                  backgroundColor: ColorConstants.buttonSecondary,
                  textColor: ColorConstants.darkText,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tileOption(String title, String leadingIcon, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.standard),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: 0.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius + 4)),
        tileColor: ColorConstants.bottomTileColor,
        contentPadding: EdgeInsets.symmetric(
            horizontal: Spacing.standard, vertical: Spacing.small),
        titleTextStyle: TextStyle(
            fontFamily: AppConstants.urbanistFont,
            fontSize: AppConstants.font14Px,
            fontWeight: FontWeight.w600,
            color: ColorConstants.darkText),
        title: Row(
          children: [
            SvgPicture.asset(leadingIcon),
            SizedBox(width: Spacing.standard,),
            CustomText(
              text: title,
              size: AppConstants.font14Px,
              weight: FontWeight.w600,
              textColor: ColorConstants.darkText,
            ),
          ],
        ),
        onTap: () {
          onTap();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
