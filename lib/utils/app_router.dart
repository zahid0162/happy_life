import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRouter{

   static pushNamed({required BuildContext context,required String route,dynamic arguments}){
      Navigator.pushNamed(context, route,arguments: arguments);
   }

   static pushReplaceNamed({required BuildContext context,required String route,dynamic arguments}){
     Navigator.pushReplacementNamed(context, route,arguments: arguments);
   }

   static pop({required BuildContext context}){
     Navigator.pop(context);
   }


   static pushNamedRemoveUntil({required BuildContext context, required String route,dynamic arguments}){
     Navigator.of(context)
         .pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false,arguments: arguments);
   }

   static popUntil({required BuildContext context, required String route}) {
     Navigator.of(context).popUntil(ModalRoute.withName(route));
   }





}