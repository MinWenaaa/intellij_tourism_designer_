import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
/*
* 制作主题颜色
*/

class AppColors {
  AppColors._();

  static const Color primary = Color(0xffff7287);
  static const Color secondary = Color(0xffe9e4ff);
  static const Color backGroundColor = Color(0xfff6efef);
  static const Color highlight = Color(0xfffff8f7);
  static const Color deepSecondary = Color(0xff8995d4);
  static const Color headline = Colors.black87;
  static const Color matter = Color(0xff444444);
  static const Color detail = Colors.black38;
}

class AppText {
  AppText._();

  static TextStyle Head1 = TextStyle(color: AppColors.headline, fontSize: 48.r);
  static TextStyle primaryHead = TextStyle(color: AppColors.primary, fontSize: 48.r);
  static TextStyle secodaryHead = TextStyle(color: AppColors.deepSecondary, fontSize: 48.r);
  static TextStyle whiteHead = TextStyle(color: Colors.white, fontSize: 48.r);
  static TextStyle Head2 = TextStyle(color: AppColors.headline, fontSize: 42.r);
  static TextStyle matter = TextStyle(color: AppColors.matter, fontSize: 36.r);
  static TextStyle detail = TextStyle(color: AppColors.detail, fontSize: 36.r);

}


Widget primaryInkWell({
  required callback, required String text,
  double width=180, double height=52
}){
  return InkWell(
    onTap: callback,
    child: Container(
      width: width, height: height, alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        color: AppColors.primary
      ),
      child: Text(text, style: AppText.whiteHead,),
    ),
  );
}

Widget secondaryInkWell({
  required callback, required String text,
  double width=180, double height=52
}){
  return InkWell(
    onTap: callback,
    child: Container(
      width: width, height: height, alignment: Alignment.center,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(26)),
          color: AppColors.secondary
      ),
      child: Text(text, style: AppText.Head1,),
    ),
  );
}

Widget transpDeepSecGesture({
  required callback, required String text,
  double width=180, double height=52
}){
  return GestureDetector(
    onTap: callback,
    child: Container(
      width: width, height: height, alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.deepSecondary, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(26))
      ),
      child: Text(text, style: AppText.secodaryHead),
    ),
  );
}
