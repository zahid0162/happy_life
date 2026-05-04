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
class CountrySelectorBottomSheet extends StatefulWidget {
  String? selectedCountry;
  CountrySelectorBottomSheet({super.key, required this.selectedCountry});

  @override
  State createState() =>
      _CountrySelectorBottomSheetState();
}

class _CountrySelectorBottomSheetState
    extends State<CountrySelectorBottomSheet> {
  final List<Map<String, String>> countries = [
    {"name": "Australia", "flag": AppIcons.flagOfAus},
    {"name": "Canada", "flag": AppIcons.flagOfCanada},
    {"name": "United States", "flag": AppIcons.flagOfUsa}
  ];
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = countries;
  }

  void filterCountries(String query) {
    setState(() {
      filteredCountries = countries
          .where((country) =>
          country["name"]!.toLowerCase().contains(query.toLowerCase()))
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
                SizedBox(height: Spacing.standard,),
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
                CustomText(text: AppConstants.selectCountry, weight: FontWeight.w600,size: AppConstants.font16Px),
                SizedBox(height: Spacing.standard,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.standard),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: CustomTextField(
                    textEditingController: _searchController,
                    label: "",
                    radius: AppConstants.defaultRadius-4,
                    filledColor: ColorConstants.homeScreenBackground,
                    borderSide: null,
                    prefixIcon: SvgPicture.asset(AppIcons.search, width: AppConstants.defaultIconSize, height: AppConstants.defaultIconSize,fit: BoxFit.none,),
                    hint: AppConstants.search,
                    onChange: (query) {
                      setModalState(() {
                        filteredCountries = countries
                            .where((country) => country["name"]!
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                countryList(setModalState),

                SizedBox(height: Spacing.standard*2,),

              ],
            ),
            doneButton(),
          ],

        );
      },
    );
  }

  Widget doneButton(){
    return Positioned(
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
            Navigator.pop(context, widget.selectedCountry);
          },
          title: AppConstants.done,
          radius: AppConstants.defaultButtonRadius,
        ),
      ),
    );
  }

  Widget countryList(StateSetter setModalState){
    return filteredCountries.isNotEmpty ? ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: Spacing.standard),
      shrinkWrap: true,
      itemCount: filteredCountries.length,
      separatorBuilder: (context, index) =>
      const SizedBox(height: Spacing.standard,),
      itemBuilder: (context, index) {
        final country = filteredCountries[index];
        return ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: ColorConstants.bottomTileColor,
          contentPadding: EdgeInsets.only(left: Spacing.standard),
          titleTextStyle: TextStyle(
              fontFamily: AppConstants.urbanistFont,
              fontSize: AppConstants.font14Px,
              fontWeight: FontWeight.w600,
              color: ColorConstants.darkText),
          leading: Image.asset(
            country["flag"]!,
          ),
          title: CustomText(
              text: country['name'] ?? '',
              size: AppConstants.font14Px,
              weight: FontWeight.w600,
              textColor: ColorConstants.darkText,
          ),
          trailing: Radio<String>(
            fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return ColorConstants.primary; // Color when selected
                }
                return ColorConstants.darkText; // Color when unselected
              },
            ),
            activeColor: ColorConstants.primary,
            value: country["name"]!,
            groupValue: widget.selectedCountry,
            onChanged: (value) {
              setState(() {
                widget.selectedCountry = value;
              });
              setState(() {
                widget.selectedCountry = country["name"]!;
              });
            },
          ),
          onTap: () {
            setModalState((){
              widget.selectedCountry = country["name"]!;
            });
            setState(() {
              widget.selectedCountry = country["name"]!;
            });
          },
        );
      },
    ) : Flexible(
      child: Padding(
        padding: EdgeInsets.only(bottom: 100.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(text: "No result found!", weight: FontWeight.w600,size: AppConstants.font16Px,),
          ],
        ),
      ),
    );
  }
}