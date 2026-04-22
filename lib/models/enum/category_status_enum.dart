import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';

enum CategoryStatus {
  Sad(statusCode: 0, iconName: AppIcons.categorySad),
  Neutral(statusCode: 1, iconName: AppIcons.categoryNeutral),
  Happy(statusCode: 2, iconName: AppIcons.categoryHappy),
  NOT_DEFINED(statusCode: 3, iconName: AppIcons.add);

  final int statusCode;
  final String iconName;

  const CategoryStatus({required this.statusCode, required this.iconName});

  // Method to get Status from statusCode
  static CategoryStatus fromCode(int code) {
    return CategoryStatus.values.firstWhere(
          (status) => status.statusCode == code,
      orElse: () => CategoryStatus.Neutral, // Default to Neutral if not found
    );
  }
  factory CategoryStatus.fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case "happy":
        return CategoryStatus.Happy;
      case "sad":
        return CategoryStatus.Sad;
      case "neutral":
        return CategoryStatus.Neutral;
      default:
        return CategoryStatus.NOT_DEFINED;
    }
  }

}
