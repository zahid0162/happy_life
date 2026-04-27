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

class DatePickerSheet extends StatefulWidget {
  String title;
  DateTime selectedDate;
  final DateTime firstDay;
  final DateTime lastDay;

  DatePickerSheet(
      {super.key,
      required this.selectedDate,
      required this.firstDay,
        required this.title,
      required this.lastDay});

  @override
  State createState() => _CountrySelectorBottomSheetState();
}

class _CountrySelectorBottomSheetState extends State<DatePickerSheet> {
  bool showSlider = false;

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
                      vertical: Spacing.standard, horizontal: Spacing.xlarge),
                  decoration: BoxDecoration(
                      color: ColorConstants.homeScreenBackground,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: ColorConstants.borderColor, width: 1)),
                  child: showSlider == false
                      ? TableCalendar(
                          firstDay: widget.firstDay,
                          lastDay: widget.lastDay,
                          currentDay: widget.selectedDate,
                          onDaySelected: (day, day1) {
                            setModalState(() {
                              widget.selectedDate = day;
                            });
                            setState(() {
                              widget.selectedDate = day;
                            });
                          },
                          availableCalendarFormats: {CalendarFormat.month: ''},
                          calendarFormat: CalendarFormat.month,
                          focusedDay: widget.selectedDate,
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            isTodayHighlighted: true,
                            weekendTextStyle: TextStyle(
                                fontFamily: AppConstants.urbanistFont,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.calendarHeader,
                                fontSize: AppConstants.font16Px),
                            disabledTextStyle: TextStyle(
                                fontFamily: AppConstants.urbanistFont,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.calendarDayHeader,
                                fontSize: AppConstants.font16Px),
                            defaultTextStyle: TextStyle(
                                fontFamily: AppConstants.urbanistFont,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.calendarHeader,
                                fontSize: AppConstants.font16Px),
                            todayDecoration: BoxDecoration(
                                color: ColorConstants.primary,
                                shape: BoxShape.circle),
                            todayTextStyle: TextStyle(
                                fontFamily: AppConstants.urbanistFont,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.homeScreenBackground,
                                fontSize: AppConstants.font16Px),
                          ),
                          calendarBuilders: CalendarBuilders(
                              headerTitleBuilder: (context, day) {
                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showSlider = true;
                                  });
                                  setModalState(() {
                                    showSlider = true;
                                  });
                                },
                                child: CustomText(
                                  textDecoration: TextDecoration.underline,
                                  text:
                                      "${DateFormat('MMMM').format(day)} ${day.year}",
                                  weight: FontWeight.w700,
                                  textColor: ColorConstants.calendarHeader,
                                ),
                              ),
                            );
                          }),
                          headerStyle: HeaderStyle(
                              headerPadding: EdgeInsets.symmetric(vertical: 0),
                              leftChevronMargin: EdgeInsets.all(0),
                              rightChevronMargin: EdgeInsets.all(0),
                              titleCentered: true,
                              leftChevronIcon: Icon(Icons.chevron_left,
                                  color: ColorConstants.calendarDayHeader),
                              rightChevronIcon: Icon(Icons.chevron_right,
                                  color: ColorConstants.calendarDayHeader)),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                                fontFamily: AppConstants.urbanistFont,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.calendarDayHeader,
                                fontSize: AppConstants.font10Px),
                            weekendStyle: TextStyle(
                                fontFamily: AppConstants.urbanistFont,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.calendarDayHeader,
                                fontSize: AppConstants.font10Px),
                          ),
                        )
                      : SizedBox(
                          height: 308.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showSlider = false;
                                  });
                                  setModalState(() {
                                    showSlider = false;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: Spacing.regular),
                                  child: CustomText(
                                    textDecoration: TextDecoration.underline,
                                    text:
                                    "${DateFormat('MMMM').format(widget.selectedDate)} ${widget.selectedDate.year}",
                                    weight: FontWeight.w700,
                                    textColor: ColorConstants.calendarHeader,
                                  ),
                                ),
                              ),
                              SizedBox(height: Spacing.standard,),
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
                                  initialDateTime: _getDateWithoutTime(widget.selectedDate),
                                  mode: CupertinoDatePickerMode.date,
                                  minimumDate: _getDateWithoutTime(widget.firstDay),
                                  maximumDate: _getDateWithoutTime(widget.lastDay),
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

  DateTime _getDateWithoutTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
