import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/helpers/POI_builder.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';

class Poidetailpage extends StatefulWidget {
  const Poidetailpage({super.key});

  @override
  State<Poidetailpage> createState() => _PoidetailpageState();
}

class _PoidetailpageState extends State<Poidetailpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          POIDetailedView(poi: POI()),
          GestureDetector(
            onTap: (){
              RouteUtils.pop(context);
            },
            child: Container(
              child: Icon(Icons.arrow_back_ios),
            ),
          )
        ]
      ),
    );
  }
}
