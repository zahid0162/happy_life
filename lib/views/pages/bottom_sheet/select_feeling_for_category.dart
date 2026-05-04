import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/models/dashboard/category.dart';
import 'package:my_happy_work_place/models/enum/category_status_enum.dart';
import 'package:my_happy_work_place/models/enum/gender_enum.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/spacing.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

class SelectCategoryFeeling extends StatefulWidget {
  String title;

  SelectCategoryFeeling({super.key, required this.title});

  @override
  State createState() => _CountrySelectorBottomSheetState();
}

class _CountrySelectorBottomSheetState extends State<SelectCategoryFeeling> {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xxlarge*2),
                child: CustomText(
                  align: TextAlign.center,
                    text: "${AppConstants.howYouFeelAboutThisToday} ${widget.title} ${AppConstants.todayQ}",
                    weight: FontWeight.w600,
                    size: AppConstants.font30Px),
              ),
              SizedBox(
                height: Spacing.standard,
              ),
              SizedBox(
                height: Spacing.standard,
              ),
              categoryStatusView(setModalState),
            ],
          ),
        );
      },
    );
  }

  Widget categoryStatusView(StateSetter setModalState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxlarge*2, horizontal: Spacing.xxxxlarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          singleStatus(CategoryStatus.Sad,setModalState),
          singleStatus(CategoryStatus.Neutral, setModalState),
          singleStatus(CategoryStatus.Happy, setModalState)
        ],
      ),
    );
  }

  Widget singleStatus(CategoryStatus status,StateSetter setModalState){
    return GestureDetector(
      onTap: (){
        Navigator.pop(context, status);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            width: 80.w,
            height: 75.h,
            status.iconName
          ),
          Padding(
            padding: const EdgeInsets.only(top: Spacing.medium),
            child: CustomText(text: status.name, weight: FontWeight.w600,size: AppConstants.font18Px,),
          )
        ],
      ),
    );
  }
}
