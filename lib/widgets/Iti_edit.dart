import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:intellij_tourism_designer/models/plan_edit_model.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:provider/provider.dart';
import '../helpers/Iti_data.dart';
import '../models/global_model.dart';

//编辑行程

class ItiEditWidget extends StatefulWidget {

  const ItiEditWidget({super.key});

  @override
  State<ItiEditWidget> createState() => _ItiEditWidgetState();
}

class _ItiEditWidgetState extends State<ItiEditWidget> {


  @override
  Widget build(BuildContext context) {
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
                  child: Selector<PlanEditModel, List<Widget>>(
                    selector: (context, provider) => provider.widgets,
                    builder: (context, widgets, child) {
                      print("provider.planData.itidata![provider.curday] changed");
                      return ListView(
                        children: widgets,
                      );
                    }
                  )
                ) : Center(
                  child: SizedBox(height: 36, width: 36,
                  child: const CircularProgressIndicator(color: AppColors.primary,))
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