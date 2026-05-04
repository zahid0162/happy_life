import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class TimePickerSheet extends StatefulWidget {
  String title;
  DateTime selectedDate;

  TimePickerSheet(
      {super.key,
        required this.selectedDate,
        required this.title,});

  @override
  State createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet> {


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
                  text: widget.title,
                  weight: FontWeight.w600,
                  size: AppConstants.font16Px),
              SizedBox(
                height: Spacing.standard,
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: Spacing.xxlarge),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Spacing.xlarge),
                  decoration: BoxDecoration(
                      color: ColorConstants.homeScreenBackground,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: ColorConstants.borderColor, width: 1)),
                  child:SizedBox(
                    height: 260.h,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 260.h,
                          child: CupertinoDatePicker(
                            onDateTimeChanged: (dateTime) {
                              setModalState(() {
                                widget.selectedDate = dateTime;
                              });
                              setState(() {
                                widget.selectedDate = dateTime;
                              });
                            },
                              initialDateTime: widget.selectedDate,
                            mode: CupertinoDatePickerMode.time
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Spacing.standard,
              ),
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
                    Navigator.pop(context, widget.selectedDate);
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
}
