import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:provider/provider.dart';
import '../helpers/Iti_data.dart';
import '../models/global_model.dart';

//编辑行程

class ItiEditWidget extends StatefulWidget {

  final DateTime startDay;
  final int days;
  final void Function()? callback;
  final String? requirement;
  const ItiEditWidget({required this.callback, required this.startDay, required this.days, this.requirement, super.key});

  @override
  State<ItiEditWidget> createState() => _ItiEditWidgetState();
}

class _ItiEditWidgetState extends State<ItiEditWidget> {

  int curDay=0;

  late Future<PlanData> planData;

  Future<PlanData> fetchPlan() async {
    final vm = Provider.of<GlobalModel>(context,listen: false);
    PlanData plan = PlanData.createWithDays(num: widget.days, uid: vm.user.uid??0);
    if(widget.requirement == ""){
      print("create with num");
      return plan;
    }else{
      print("create with llm : ${widget.requirement}");
      List<List<ItiData>> list = await Api.instance.design_LLM(poinNum: widget.days*3, requirement: widget.requirement??"")??[[]];
      plan.itidata = list;
      print("widget data: ${plan}");
      return plan;
    }
  }

  @override
  void initState() {
    super.initState();
    planData = fetchPlan();
  }


  void _onItemTapped(int index) {
    curDay = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children:[
          Flexible(flex:1, child: _days(),),
          Flexible(
            flex:5,
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              children:[
                const SizedBox(height:5),
                WeatherCard(date: widget.startDay.add(Duration(days: curDay))),
                const SizedBox(height:5),
                FutureBuilder<PlanData>(
                  future: planData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: SizedBox(
                            height: 36, width: 36,
                              child: const CircularProgressIndicator(color: AppColors.primary,))
                      );
                    } else {
                      return SizedBox(
                        height: 500,
                        child: ListView(
                            children: List.generate(
                                snapshot.data!.itidata![curDay].length,
                                (index){
                                  //print("${curDay}, ${snapshot.data!.itidata![curDay].length}, ${index}");
                                  //print("${snapshot.data!.itidata}");
                                    return _ItiCard(snapshot.data!.itidata![curDay][index]);
                             })
                        ),
                      );
                    }
                  }
                ),
                FutureBuilder<PlanData>(
                  future: planData,
                  builder: (context, snapshot) => snapshot.hasData ?
                    TextButton(
                      onPressed: () => setState((){
                          snapshot.data!.itidata![curDay].add(ItiData());
                      }),
                      style:AppButton.button1,
                      child:const Icon(Icons.add),
                    ) : const SizedBox(),
                )
              ]
            )
          )
        ]
    );
  }

  Widget _days(){
    return Container(
        child:Column(
          children: [
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: widget.callback,
              child: Container(
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: _navigation()
            ),
            FutureBuilder<PlanData>(
              future: planData,
              builder: (context, snapshot) => snapshot.hasData ?
                TextButton(
                  onPressed:() => setState(() {
                    snapshot.data!.itidata!.add([]);
                    curDay=snapshot.data!.itidata!.length-1;}),
                  child:const Text("Add"),
                ): const SizedBox(),
            ),
            const SizedBox(height: 10,),
          ],
        )
    );
  }

  Widget _navigation(){
    return FutureBuilder<PlanData>(
      future: planData,
      builder: (context, snapshot) => snapshot.hasData ?
        NavigationRail(
          destinations: List.generate(snapshot.data!.itidata!.length, (index)=>NavigationRailDestination(
            icon: Text("Day${index+1}"),
            label: Text("Day${index+1}"),
          )),
          selectedIndex: curDay,
          onDestinationSelected: _onItemTapped,
      ): const SizedBox(),
    );
  }

  Widget _ItiCard(ItiData itiData){
    return Container(
      width: 320, height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.secondary
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Text(itiData.pname??"未知点"),
                Text(itiData.pintroduceShort??"")
              ],
            ),
          ),
          Flexible(
              flex: 2,
              child: Image.network(itiData.pphoto ??
                  "https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp",
                fit: BoxFit.cover,
                width: double.infinity, height: double.infinity,
              )
          )
        ],
      ),
    );
  }


}