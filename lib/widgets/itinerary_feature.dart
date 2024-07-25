import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
//import 'package:intellij_tourism_designer/helpers/POI_builder.dart';

//自动规划行程的页面，主要时一些个性设置

class ItiFeature extends StatefulWidget {
  const ItiFeature({super.key});

  @override
  State<ItiFeature> createState() => _ItiFeatureState();
}

class _ItiFeatureState extends State<ItiFeature> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        SizedBox(height:120, child:timeEditor()),
        const SizedBox(height:5),
        SizedBox(height:120, child:timeEditor()),
        const SizedBox(height:5),
        TextButton(
          onPressed:(){},
          style:AppButton.button1,
          child:const Text("确定"),
        ),
      ]
    );
  }
}

EasyDateTimeLine timeEditor() {
  return EasyDateTimeLine(
    initialDate: DateTime.now(),
    onDateChange: (selectedDate) {
      //`selectedDate` the new date selected.
    },
    dayProps: const EasyDayProps(
      height: 48.0,
      width: 104.0,
    ),
    headerProps: const EasyHeaderProps(
      dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
    ),
    itemBuilder: (BuildContext, DateTime, bool, void Function()){
      return Text("?");
  }
  );
}
