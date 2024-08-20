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

  static TextStyle bigHead = TextStyle(color: AppColors.headline, fontSize: 64.r);
  static TextStyle Head1 = TextStyle(color: AppColors.headline, fontSize: 48.r);
  static TextStyle primaryHead = TextStyle(color: AppColors.primary, fontSize: 48.r);
  static TextStyle secodaryHead = TextStyle(color: AppColors.deepSecondary, fontSize: 48.r);
  static TextStyle whiteHead = TextStyle(color: Colors.white, fontSize: 48.r);
  static TextStyle Head2 = TextStyle(color: AppColors.headline, fontSize: 42.r);
  static TextStyle lightHead2 = TextStyle(color: AppColors.matter, fontSize: 42.r);
  static TextStyle matter = TextStyle(color: AppColors.matter, fontSize: 36.r);
  static TextStyle detail = TextStyle(color: AppColors.detail, fontSize: 36.r);

}


Widget primaryInkWell({
  required callback, required String text,
  double width=180, double height=52
}){
  return GestureDetector(
    onTap: callback,
    child: Container(
      width: width, height: height, alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(height/2)),
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.detail.withOpacity(0.15),
            spreadRadius: 3.r,
            blurRadius: 7.r,
            offset: Offset(0, 6.r),
          )
        ] //
      ),
      child: Text(text, style: AppText.whiteHead,),
    ),
  );
}

Widget secondaryInkWell({
  required callback, required String text,
  double? width, double? height,
}){
  return GestureDetector(
    onTap: callback,
    child: Container(
      width: width??460.w, height: height??134.h, alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height??134.h/2)),
          color: AppColors.secondary,
          boxShadow: [
            BoxShadow(
              color: AppColors.detail.withOpacity(0.15),
              spreadRadius: 3.r,
              blurRadius: 7.r,
              offset: Offset(0, 6.r),
            )
          ] // changes position of shadow
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
        borderRadius: BorderRadius.all(Radius.circular(height/2))
      ),
      child: Text(text, style: AppText.secodaryHead),
    ),
  );
}
