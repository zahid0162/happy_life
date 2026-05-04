import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_textfield.dart';

class CitySelectorBottomSheet extends StatefulWidget {
  String? selectedCity;

  CitySelectorBottomSheet({super.key, required this.selectedCity});

  @override
  State createState() => _CitySelectorBottomSheetState();
}

class _CitySelectorBottomSheetState extends State<CitySelectorBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = AppConstants.australianCities;
  }

  void filterCities(String query) {
    setState(() {
      filteredCities = AppConstants.australianCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  color: ColorConstants.homeScreenBackground,
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
                        text: AppConstants.selectCity,
                        weight: FontWeight.w600,
                        size: AppConstants.font16Px,
                      ),
                      SizedBox(height: Spacing.standard),
                      // Search Field
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Spacing.standard),
                        child: CustomTextField(
                          textEditingController: _searchController,
                          label: "",
                          radius: 12,
                          filledColor: ColorConstants.homeScreenBackground,
                          borderSide: null,
                          prefixIcon: SvgPicture.asset(
                            AppIcons.search,
                            width: 24,
                            height: 24,
                            fit: BoxFit.none,
                          ),
                          hint: AppConstants.search,
                          onChange: (query) {
                            setModalState(() {
                              filterCities(query);
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // Cities List
                Flexible(
                  child: filteredCities.isNotEmpty
                      ? ListView.separated(
                          padding: EdgeInsets.only(
                              left: Spacing.standard,
                              right: Spacing.standard,
                              bottom: Spacing.xxxxlarge * 2),
                          shrinkWrap: true,
                          itemCount: filteredCities.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Spacing.standard),
                          itemBuilder: (context, index) {
                            final city = filteredCities[index];
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
                                text: city,
                                size: AppConstants.font14Px,
                                weight: FontWeight.w600,
                                textColor: ColorConstants.darkText,
                              ),
                              trailing: Radio<String>(
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
                                value: city,
                                groupValue: widget.selectedCity,
                                onChanged: (value) {
                                  setState(() {
                                    widget.selectedCity = value;
                                  });
                                },
                              ),
                              onTap: () {
                                setModalState(() {
                                  widget.selectedCity = city;
                                });
                                setState(() {
                                  widget.selectedCity = city;
                                });
                              },
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 100.h),
                              child: CustomText(
                                text: "No result found!",
                                weight: FontWeight.w600,
                                size: AppConstants.font16Px,
                              ),
                            ),
                          ],
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
                    Navigator.pop(context, widget.selectedCity);
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
