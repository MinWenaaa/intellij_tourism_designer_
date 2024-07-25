import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/widgets/chart_view.dart';
//import 'package:intellij_tourism_designer/constants/theme.dart';
//import 'package:intellij_tourism_designer/widgets/detail_view.dart';

//城市旅游信息页面

class CityStatsPage extends StatefulWidget {
  const CityStatsPage({super.key});

  @override
  State<CityStatsPage> createState() => _CityStatsPageState();
}

class _CityStatsPageState extends State<CityStatsPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height - AppSize.buttonHeight1,
      width:size.width-AppSize.toolBarWidth1,
      child:const CityFeatureStackBarChart()
    );
  }
}
