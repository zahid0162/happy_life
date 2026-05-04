import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../../models/dashboard/category.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class SelectCategorySheet extends StatefulWidget {
  Category? selectedCategory;
  List<Category> categories;

  SelectCategorySheet({super.key, required this.selectedCategory, required this.categories});

  @override
  State createState() => _SelectCategorySheetState();
}

class _SelectCategorySheetState extends State<SelectCategorySheet> {

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.homeScreenBackground,
                    borderRadius: BorderRadius.circular(AppConstants.defaultRadius)
                  ),
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
                      SizedBox(height: Spacing.standard),
                      // Title
                      CustomText(
                        text: AppConstants.selectCategory,
                        weight: FontWeight.w600,
                        size: AppConstants.font16Px,
                      ),
                      SizedBox(height: Spacing.standard),
                    ],
                  ),
                ),
                // Cities List
                Flexible(
                  child: ListView.separated(
                          padding: EdgeInsets.only(
                              left: Spacing.standard,
                              right: Spacing.standard,
                              bottom: Spacing.xxxxlarge * 2),
                          shrinkWrap: true,
                          itemCount: widget.categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Spacing.standard),
                          itemBuilder: (context, index) {
                            final cate = widget.categories[index];
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: ColorConstants.bottomTileColor,
                              contentPadding:
                                  EdgeInsets.only(left: Spacing.standard),
                              titleTextStyle: TextStyle(
                                fontFamily: AppConstants.urbanistFont,
                                fontSize: AppConstants.font14Px,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.darkText,
                              ),
                              title: CustomText(
                                text: cate.title,
                                size: AppConstants.font14Px,
                                weight: FontWeight.w600,
                                textColor: ColorConstants.darkText,
                              ),
                              trailing: Radio<Category>(
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return ColorConstants
                                          .primary; // Color when selected
                                    }
                                    return ColorConstants
                                        .darkText; // Color when unselected
                                  },
                                ),
                                activeColor: ColorConstants.primary,
                                value: cate,
                                groupValue: widget.selectedCategory,
                                onChanged: (value) {
                                  setState(() {
                                    widget.selectedCategory = cate;
                                  });
                                },
                              ),
                              onTap: () {
                                setModalState(() {
                                  widget.selectedCategory = cate;
                                });
                                setState(() {
                                  widget.selectedCategory = cate;
                                });
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 80), // Padding for floating button
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
                    Navigator.pop(context, widget.selectedCategory);
                  },
                  title: AppConstants.done,
                  radius: AppConstants.defaultButtonRadius,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
