import 'dart:ui';

import 'package:flutter/material.dart';
/*
* 制作主题颜色
*/
class AppColors2 {
  AppColors2._();

  static const Color primaryColor = Color(0xFFFFDE59); // 主色调
  static const Color primaryColor2 = Color(0xCCFFDE59);
  static const Color primaryColor3 = Color(0x59FFDE59);
  static const Color secondaryColor = Color(0xffCCD6DD); // 辅助色
  static const Color accentColor = Color(0xff00008b); // 强调色
  static const Color backgroundColor = Color(0xFFFFFFFF); // 背景色
  static const Color textColor = Color(0xff737373); // 文本颜色
}

class AppColors {
  AppColors._();

  static const Color primary = Color(0xffff7287);
  static const Color secondary = Color(0xffe9e4ff);
  static const Color deepSecondary = Color(0xff8995d4);
  static const Color headline = Colors.black87;
  static const Color matter = Color(0xff444444);
  static const Color detail = Colors.black38;
}

class AppText {
  AppText._();

  static const TextStyle Head1 = TextStyle(color: AppColors.headline, fontSize: 20);
  static const TextStyle primaryHead = TextStyle(color: AppColors.primary, fontSize: 20);
  static const TextStyle secodaryHead = TextStyle(color: AppColors.deepSecondary, fontSize: 20);
  static const TextStyle whiteHead = TextStyle(color: Colors.white, fontSize: 20);
  static const TextStyle Head2 = TextStyle(color: AppColors.headline, fontSize: 16);
  static const TextStyle matter = TextStyle(color: AppColors.matter, fontSize: 16);
  static const TextStyle detail = TextStyle(color: AppColors.detail, fontSize: 14);

}

class AppButton{
  AppButton._();

  static final ButtonStyle button1 = ElevatedButton.styleFrom(
      backgroundColor:AppColors.primary,
      //foregroundColor:AppColors.background,
      textStyle:AppText.matter,
      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
  );
  static final ButtonStyle button2 = ElevatedButton.styleFrom(
      //backgroundColor:AppColors1.backgroundColor,
      //foregroundColor:AppColors1.primaryColor,
      //textStyle:AppText.bgStandard,
      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
  );
  static final ButtonStyle button3 = ElevatedButton.styleFrom(
    //backgroundColor:AppColors1.primaryColor3,
      //shadowColor:AppColors1.primaryColor2,
      //foregroundColor:AppColors1.textColor,
      textStyle:AppText.matter
  );
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


class AppSize{
  static const double buttonHeight2=42;
  static const double buttonHeight1=48;
  static const double topBarHeight=50;
  static const double buttonWidth1=90;
  static const double toolBarWidth1=150;
  static const double selectViewWidth=180;
  static const double contentWidth3=320;
  static const double contentWidth1=400;
  static const double imgHeight1=400;
  static const double contentWidth2=520;
}