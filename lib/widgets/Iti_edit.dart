import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/plan_edit_model.dart';
import 'package:intellij_tourism_designer/widgets/LLM_chat_room.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../helpers/Iti_data.dart';

//编辑行程

class ItiEditWidget extends StatefulWidget {
  final Function(LatLng, double) callBack;

  const ItiEditWidget({super.key, required this.callBack});

  @override
  State<ItiEditWidget> createState() => _ItiEditWidgetState();
}

class _ItiEditWidgetState extends State<ItiEditWidget> {

  bool isLLM = false;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _EditWidget(),
        Visibility(
          visible: isLLM,
          child: LLMChatRoom(
            move: widget.callBack,
            back: ()=> setState(() {
              isLLM = false;
            }),)
        ),
      ],
    );
  }



  Widget _EditWidget() {
    final vm = Provider.of<PlanEditModel>(context,listen: false);
    return Row(
      children:[
        Flexible(flex:1, child: _days(context),),
        Flexible(
          flex:6, child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            children:[
              const SizedBox(height:5),
              Selector<PlanEditModel, int>(
                selector: (context, provider) => provider.curday,
                builder: (context, data, child) => WeatherCard(date: vm.start.add(Duration(days: data)))),
              const SizedBox(height:5),
              Selector<PlanEditModel, bool>(
                selector: (context, provider) => provider.hasData,
                builder: (context, dataState, child) => dataState ? SizedBox(
                  height: 500,
                  child: Selector<PlanEditModel, List<ItiData>>(
                    selector: (context, provider) => provider.curData,
                    builder: (context, curData, child) {
                      List<Widget> widgets = [];
                      curData.forEach((iti) => widgets.add(ActCard(itiData: iti)));
                      print("provider.planData.itidata![provider.curday] changed");
                      return ReorderableListView(
                        onReorder: (oldIndex, newIndex) => vm.reorderPlan(oldIndex, newIndex),
                        children: List.generate(widgets.length, (index) => GestureDetector(
                          key: ValueKey(curData[index]),
                          onTap: () => widget.callBack.call(LatLng(curData[index].y??30, curData[index].x??114), 16.5),
                          child: ListTile(
                            title: widgets[index]),
                        ))
                      );
                    }
                  )
                ) : const Center(
                  child: SizedBox(height: 36, width: 36,
                  child: CircularProgressIndicator(color: AppColors.primary,))
                )
              )
            ]
          )
        )
      ]
    );
  }

  Widget _days(BuildContext context){
    final vm = Provider.of<PlanEditModel>(context,listen: false);
    return Container(
        child:Column(
          children: [
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                vm.changeEditState(false);
                vm.changeDataState(false);
                vm.changeCurDay(0);
              },
              child: Icon(Icons.arrow_back_ios),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: _navigation()
            ),
            Selector<PlanEditModel, bool>(
              selector: (context, provider) => provider.hasData,
              builder: (context, dataState, child) => dataState ?
                Column(
                  children: [
                    TextButton(
                      onPressed: () => setState(() {
                        isLLM = true;
                      }),
                      child: Image.network(ConstantString.robot, width: 42, height: 64,)
                    ),
                    TextButton(
                      onPressed:() {
                        print("ItiEdit presses: Add");
                        vm.pushDay();
                      },
                      child:const Text("Add"),
                    ),
                    TextButton(
                      onPressed:() {
                        vm.uploadPlan();
                      },
                      child:const Text("保存"),
                    ),
                  ],
                ): const SizedBox(),
            ),
            const SizedBox(height: 10,),
          ],
        )
    );
  }

  Widget _navigation(){

    final vm = Provider.of<PlanEditModel>(context,listen: false);

    return Selector<PlanEditModel, bool>(
      selector: (context, provider) => provider.hasData,
      builder: (context, dataState, child) => dataState ?
        Selector<PlanEditModel, int>(
          selector: (context, provider) => provider.curday,
          builder: (context, curday, child) => NavigationRail(
            destinations: List.generate(vm.planData.itidata!.length, (index)=>NavigationRailDestination(
              icon: Text("Day${index+1}"),
              label: Text("Day${index+1}"),
            )),
            selectedIndex: curday,
            onDestinationSelected: vm.changeCurDay,
          ),
        ): const SizedBox(),
    );

  }



}