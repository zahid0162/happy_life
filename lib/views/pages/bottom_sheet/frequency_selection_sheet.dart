import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/color_constants.dart';
import 'package:my_happy_work_place/views/widgets/custom_text.dart';

import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';

class FrequencySelectionSheet extends StatefulWidget {
  final String lastSelectedFrequency;

  const FrequencySelectionSheet(
      {super.key, required this.lastSelectedFrequency});

  @override
  State<FrequencySelectionSheet> createState() =>
      _FrequencySelectionSheetState();
}

class _FrequencySelectionSheetState extends State<FrequencySelectionSheet> {
  String _selectedQuickOption = ''; // Holds 'Daily' or 'Mon - Fri'
  final List<String> _selectedDays = []; // Holds custom selected days
  final List<String> _daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  void initState() {
    super.initState();
    _initializeSelection(widget.lastSelectedFrequency);
  }

  // Initialize selection based on the provided frequency
  void _initializeSelection(String frequency) {
    if (frequency == 'Daily' || frequency == 'Mon - Fri') {
      _selectedQuickOption = frequency;
    } else if (frequency.isNotEmpty) {
      _selectedDays.clear();
      _selectedDays.addAll(frequency.split(', ').map((e) => e.trim()));
    }
  }

  void _selectQuickOption(String option) {
    setState(() {
      _selectedQuickOption = option;
      _selectedDays.clear();
    });
  }

  void _toggleCustomDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      _selectedQuickOption = ''; // Clear quick option selection
    });
  }

  String _generateSelectedFrequency() {
    if (_selectedQuickOption.isNotEmpty) {
      return _selectedQuickOption; // Return quick selection
    } else if (_selectedDays.isNotEmpty) {
      return _selectedDays.join(', '); // Return custom days
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Spacing.normal,
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Set Frequency:',
                weight: FontWeight.w500,
                size: AppConstants.font16Px,
              ),
            ],
          ),
          SizedBox(
            height: Spacing.standard,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: CustomText(
                text: 'Quick Selection:',
                weight: FontWeight.w500,
                size: AppConstants.font14Px,
                textColor: ColorConstants.blackInputText,
              ),
            ),
          ),
          SizedBox(height: Spacing.standard,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _quickSelectButton('Daily'),
              const SizedBox(width: 8),
              _quickSelectButton('Mon - Fri'),
            ],
          ),
          const SizedBox(height: Spacing.standard),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: CustomText(
                text: 'Select Custom Days:',
                weight: FontWeight.w500,
                size: AppConstants.font14Px,
                textColor: ColorConstants.blackInputText,
              ),
            ),
          ),
          const SizedBox(height: Spacing.standard),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _daysOfWeek.map((day) => _dayButton(day)).toList(),
          ),
          const SizedBox(height: 24),
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
                Navigator.pop(context, _generateSelectedFrequency());

              },
              title: AppConstants.done,
              radius: AppConstants.defaultButtonRadius,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickSelectButton(String text) {
    final bool isSelected = _selectedQuickOption == text;
    return GestureDetector(
      onTap: () => _selectQuickOption(text),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? ColorConstants.primary.withOpacity(0.1)
              : ColorConstants.genderUnselectedBgColor,
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius + 4),
        ),
        padding: const EdgeInsets.symmetric(vertical: Spacing.normal, horizontal: Spacing.xxxxlarge-2),
        margin: EdgeInsets.only(left: Spacing.standard),
        alignment: Alignment.center,
        child: CustomText(
          text: text,
          textColor: isSelected
              ? ColorConstants.primary
              : ColorConstants.blackInputText.withOpacity(0.5),
          weight: FontWeight.w600,
          size: AppConstants.font14Px,
        ),
      ),
    );
  }

  Widget _dayButton(String day) {
    final bool isSelected = _selectedDays.contains(day);
    return GestureDetector(
      onTap: () => _toggleCustomDay(day),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? ColorConstants.primary.withOpacity(0.1)
              : ColorConstants.genderUnselectedBgColor,
          shape: BoxShape.circle
        ),
        padding: const EdgeInsets.all(Spacing.standard-4),
        alignment: Alignment.center,
        child: CustomText(
          text: day,
          textColor: isSelected
              ? ColorConstants.primary
              : ColorConstants.blackInputText.withOpacity(0.5),
          weight: FontWeight.w600,
          size: AppConstants.font14Px,
        ),
      ),
    );
  }
}
