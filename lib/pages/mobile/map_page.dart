import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/widgets/map_view.dart';

/*
  地图查看模块
 */

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Expanded(
              child: DemoMap(
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _appBar(){
    return Container(
      height:30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("坐标：31.286391N, 114.2831893E"),
          Text("温度：35"),
          SizedBox(width: 20,),
          DropdownButton(items: [
              DropdownMenuItem(child: Text("专题图"),value: 1,),
              DropdownMenuItem(child: Text("专题图"),value: 2,),
              DropdownMenuItem(child: Text("专题图"),value: 3,),
            ], onChanged: (value){},
            icon: Icon(Icons.arrow_left),
            hint: SizedBox(),
            underline: Container(height: 0,),
            elevation: 0,
            isDense: true,
          )
        ],
      ),
    );
  }
}
