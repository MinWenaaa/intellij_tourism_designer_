import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/map_view.dart';
import 'package:intellij_tourism_designer/widgets/tools_button.dart';
import 'package:provider/provider.dart';
import '../../models/map_view_model.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {

  MapViewModel viewModel = MapViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>(
      create: (context){return viewModel;},
      child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _appBar(),
                Expanded(
                  child: Stack(
                    children: [
                      DemoMap(),
                      ToolsButton(),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              child: Container(
                                child: Text("返回主页"),
                              ),
                              onTap: (){RouteUtils.pop(context);},
                            ),
                            GestureDetector(
                              child: Container(
                                child: Text("停止记录"),
                              ),
                              onTap: (){},
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget _appBar(){
    return Container(
      height:30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("坐标：31.286391N, 114.2831893E"),
          Text("温度：35"),
        ],
      ),
    );
  }


}
