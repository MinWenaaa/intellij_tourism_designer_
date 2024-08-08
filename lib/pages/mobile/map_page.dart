import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/models/map_view_model.dart';
import 'package:intellij_tourism_designer/pages/mobile/record_page.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/map_view.dart';
import 'package:intellij_tourism_designer/widgets/tools_button.dart';
import 'package:provider/provider.dart';

/*
  地图查看模块
 */

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  MapViewModel viewModel = MapViewModel();

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>(
      create: (context){return viewModel;},
      child: Scaffold(
        body: SafeArea(
          child: Expanded(
            child:  Stack(
              children: [
                DemoMap(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    child: Text("开始记录"),
                    onPressed: (){RouteUtils.push(context, RecordPage());},
                  ),
                ),
                ToolsButton(),
              ],
            )
          ),
        )
      ),
    );
  }



}
