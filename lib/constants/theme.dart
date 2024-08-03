import 'package:flutter/material.dart';
/*
* 制作主题颜色
*/
class AppColors1 {
  AppColors1._();

  static const Color primaryColor = Color(0xFFFFDE59); // 主色调
  static const Color primaryColor2 = Color(0xCCFFDE59);
  static const Color primaryColor3 = Color(0x59FFDE59);
  static const Color secondaryColor = Color(0xffCCD6DD); // 辅助色
  static const Color accentColor = Color(0xff00008b); // 强调色
  static const Color backgroundColor = Color(0xFFFFFFFF); // 背景色
  static const Color textColor = Color(0xff737373); // 文本颜色
}

class AppText {
  AppText._();

  static const TextStyle bgStandard = TextStyle(color:AppColors1.backgroundColor,fontSize: 16);
  static const TextStyle pStandard = TextStyle(color:AppColors1.primaryColor,fontSize: 16);
  static const TextStyle Head1 = TextStyle(color: Colors.black, fontSize: 28);
  static const TextStyle Head2 = TextStyle(color: Colors.black,fontSize: 20);
  static const TextStyle standard = TextStyle(color:Colors.black87,fontSize: 16);
  static const TextStyle small = TextStyle(color:Colors.black87,fontSize: 12);
  static const TextStyle big = TextStyle(color:Colors.black87,fontSize: 16);

}

class AppButton{
  static final ButtonStyle button1 = ElevatedButton.styleFrom(
    backgroundColor:AppColors1.primaryColor,
    foregroundColor:AppColors1.backgroundColor,
    textStyle:AppText.bgStandard,
    shape:const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
  );
  static final ButtonStyle button2 = ElevatedButton.styleFrom(
      backgroundColor:AppColors1.backgroundColor,
      foregroundColor:AppColors1.primaryColor,
      textStyle:AppText.bgStandard,
      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
  );
  static final ButtonStyle button3 = ElevatedButton.styleFrom(
      //backgroundColor:AppColors1.primaryColor3,
      shadowColor:AppColors1.primaryColor2,
      foregroundColor:AppColors1.textColor,
      textStyle:AppText.small
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