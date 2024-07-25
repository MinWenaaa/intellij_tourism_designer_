import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/Constants.dart';
import 'package:intellij_tourism_designer/pages/mobile/POIDetailPage.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';

import '../../helpers/POI_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  POItype type = POItype.attraction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _typeItem(tartgetType: POItype.attraction, color: Colors.amberAccent, text: "景点"),
            _typeItem(tartgetType: POItype.dining, color: Colors.amberAccent, text: "餐饮"),
            _typeItem(tartgetType: POItype.accomodation, color: Colors.amberAccent, text: "住宿"),
            _typeItem(tartgetType: POItype.camera_postion, color: Colors.amberAccent, text: "机位"),
          ],
        ),
        Expanded(
          child: _ListView()
        ),
      ],
    );
  }


  Widget _typeItem({POItype? tartgetType, Color? color, String? text}){
    return GestureDetector(
      onTap: (){
        type = tartgetType ?? POItype.attraction;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: color ?? Colors.white
        ),
        child: Text(text??""),
      ),
    );
  }

  Widget _ListView(){
    return ListView.builder(itemBuilder: (context, index){
      return GestureDetector(
        onTap: (){
          RouteUtils.push(context, Poidetailpage());
        },
        child: POICard(style: 1, poi: POI()),
      );
    });
  }
}
