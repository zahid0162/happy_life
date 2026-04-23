
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../views/widgets/custom_text.dart';

class Utils {
  static void showSnackBar({required String message,required BuildContext context,Color? backgroundColor}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: CustomText(
      text: message,
      textColor: Colors.white,
      weight: FontWeight.w300,
    ),backgroundColor: backgroundColor ?? ColorConstants.darkText,));
  }
}