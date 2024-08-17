import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/pages/mobile/path_planing_page.dart';


class MemoryView extends StatefulWidget {
  const MemoryView({super.key});

  @override
  State<MemoryView> createState() => _MemoryViewState();
}

class _MemoryViewState extends State<MemoryView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children:[
          const PathPlanningPage(),
          Positioned(
            right:20,top:20,width:340,height:100,
            child: Card(
              //color:AppColors.primaryColor3,
              child:SizedBox()/*WeatherCard(
                weather: WeatherData(),
                width: 80, height: 50,
              )*/
            )
          ),
          Positioned(
            left: 20,top: 20,
            child: _backButton()
          )
        ]
      ),
    );
  }

  Widget _backButton(){
    return GestureDetector(
      onTap: (){
        RouteUtils.pop(context);
      },
      child: Container(
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}
