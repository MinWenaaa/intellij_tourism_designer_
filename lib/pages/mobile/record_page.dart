import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/map_view.dart';
import 'package:intellij_tourism_designer/widgets/tools_button.dart';
import 'package:provider/provider.dart';
import '../../models/global_model.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                primaryInkWell(
                                  callback: (){},
                                  text: "停止记录",
                                ),
                                secondaryInkWell(
                                    callback: () => RouteUtils.pop(context),
                                    text: "返回主页"
                                )
                              ],
                            ),
                          )
                        ]
                      )
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("坐标：31.286391N, 114.2831893E"),
          Text("温度：35"),
        ],
      ),
    );
  }



}
