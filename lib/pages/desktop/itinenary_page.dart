import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/Iti_data.dart';
import 'package:intellij_tourism_designer/pages/desktop/map_page.dart';
import 'package:intellij_tourism_designer/widgets/calendar.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../models/global_model.dart';
import '../../widgets/Iti_edit.dart';
import '../../widgets/buttom_sheet.dart';

//行程规划模块

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {

  int state = 0;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  int curDay = 0;

  bool _showTextField = false;
  final TextEditingController _textController = TextEditingController();
  String requirement = "";


  @override
  Widget build(BuildContext context) {
    //print(state);
    return Row(children: [
      state == 0 ? _createFab() : const SizedBox(),
      state == 1 ? Flexible(
        flex: 3,
        child: ItiEditWidget(
          callback: callBack, startDay: start,
          days: end.difference(start).inDays+1,
          requirement: _textController.text,
        )
      ) : const SizedBox(),
      Flexible(
        flex: 5,
          child: MapPage()),
    ]);
  }

  Widget _createFab(){
    return Flexible(
      flex: 3,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24,),
          //Text("出发时间："),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: timeSelector(callBack: (value)=>start = value)
          ),
          //Text("结束时间："),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: timeSelector(callBack: (value)=>end = value)
          ),
          Expanded(child: SizedBox(),),
          Visibility(
            visible: !_showTextField,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  primaryInkWell(
                    width: 200,
                    callback: () => setState(() {
                      state = 1;}),
                    text: "立即创建"),
                  secondaryInkWell(
                    width: 200,
                    callback: () => setState(() {
                      _showTextField = true;}),
                    text: "AI生成"),
              ]
            ),
          ),
          _aiDialog(),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }


  Widget _aiDialog(){
    return Visibility(
        visible: _showTextField,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 380,
              child: TextField(
                controller: _textController,
                onChanged: (value) => requirement = value,
                style: const TextStyle(color: AppColors.deepSecondary, fontSize: 14),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.deepSecondary),
                  ),
                  icon: Image.network("https://gd-hbimg.huaban.com/c58333b7739ae05af800a79572295c1c7360fb5bade-o3kQFE_fw1200webp", width: 36, height: 36,),
                  hintText: "输入期待的旅游要求，大模型为您生成规划",
                  labelStyle: const TextStyle(color: AppColors.deepSecondary)
                ),
              ),
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    state = 1;
                  }),
                  child: Text("确定")),
                TextButton(
                  onPressed: () => setState(() {
                    _showTextField = false;
                    _textController.clear();
                  }),
                  child: Text("取消")
                ),
              ],
            )
          ],
        )

    );
  }


  void callBack(){
    state = 0;
    setState(() {});
  }


}
