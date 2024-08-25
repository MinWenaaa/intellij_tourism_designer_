import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/path_plan_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

//这是一个路径查询的界面，计划是比较自由的，可以任意选途径点和一些个性选项

class PathQueryWidget extends StatefulWidget {
  const PathQueryWidget({super.key, required this.back, required this.move});

  final Function back;

  final Function(LatLng, double) move;

  @override
  State<PathQueryWidget> createState() => _PathQueryWidgetState();
}

class _PathQueryWidgetState extends State<PathQueryWidget> {
  List wayPoint=[];
  int transport=0;
  int strategy=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: [
          Center(
              child: const Text("途径点", style: AppText.Head1,)
          ),
          _pointFab(),
          // const SizedBox(height:10),
          // SizedBox(
          //   width:150,
          //   child: TextButton(
          //     onPressed:(){setState((){});},
          //     child:const Text("添加途径点"),
          //   ),
          // ),
          // //Divider(height:20,thickness: 1,indent:20,endIndent:20,color:AppColors1.primaryColor),
          // const SizedBox(height:20),
          // Container(
          //   height:70,
          //   color:AppColors.primary,
          //   child:Column(
          //     children: [
          //       const Text("出行方式",style:AppText.matter),
          //       Row(
          //         children:[
          //           transportButton(1,"步行"),
          //           transportButton(2,"步行"),
          //           transportButton(3,"公交"),
          //           transportButton(4,"地铁"),
          //           transportButton(5,"驾车"),
          //         ]
          //       ),
          //     ],
          //   )
          // ),
          // const SizedBox(height:20),
          // Container(
          //   height:70,
          //   color:AppColors.primary,
          //   child:Column(
          //     children: [
          //       const Text("策略",style:AppText.matter),
          //       IndexedStack(
          //         index:transport,
          //         children:[
          //           Container(),
          //           Row(
          //             children:[
          //               strategyButton(1,"距离最短"),
          //               strategyButton(2,"探索小路"),
          //               strategyButton(3,"风景不错")
          //             ]
          //           )
          //         ]
          //       ),
          //     ],
          //   )
          // ),
          // const SizedBox(height:30),
          // const Text("热门地点",style:AppText.matter),
          // SizedBox(
          //   height:300,
          //   child: infrestructureList(context)
          //)
        ],
      ),
    );
  }

  AppBar _appBar(){
    return AppBar(
      title: const Text("导航设置"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back), tooltip: 'Navigate back',
        onPressed: () => widget.back.call(),
      ),
    );
  }

  Widget _pointFab(){
    final vm = Provider.of<PathPlanModel>(context,listen: false);
    return Container(
      width: double.infinity, height: 480,
      color: AppColors.backGroundColor,
      child: Selector<PathPlanModel, List<LatLng>>(
          selector: (context, provider) => provider.points,
          builder: (context, curData, child) {
            List<Widget> widgets = [];
            curData.forEach((point) => widgets.add(_pointView(point)));
            print("provider.planData.itidata![provider.curday] changed");
            return ReorderableListView(
                onReorder: (oldIndex, newIndex) => vm.Reorder(oldIndex, newIndex),
                children: List.generate(widgets.length, (index) => GestureDetector(
                  key: ValueKey(curData[index]),
                  onTap: () => widget.move.call(curData[index], 16.5),//=> widget.callBack.call(LatLng(curData[index].y??30, curData[index].x??114), 16.5),
                  child: ListTile(
                      title: widgets[index]),
                ))
            );
          }
      ),
    );

  }

  Widget _pointView(LatLng point){
    return Container(
      width: double.infinity, height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColors.highlight,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(Icons.location_on_sharp, color: AppColors.deepSecondary, size: 42),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("经度：${point.longitude}", style: AppText.matter,),
              Text("纬度：${point.latitude}", style: AppText.matter,)
            ],
          )
        ],
      ),
    );
  }

  Widget strategyButton(int s,String child){
    return TextButton(
      onPressed:(){setState(() {strategy=s;});},
      child:Text(child),
    );
  }

  Widget transportButton(int t,String child){
    return TextButton(
      onPressed:(){setState(() {transport=t;});},
      child:Text(child),
    );
  }

  Widget infrestructureList(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: SizedBox()//POICard(style: 1, poi: model.poiList[index]),
        );
      },
    );
  }
}
