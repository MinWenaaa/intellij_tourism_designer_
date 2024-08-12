import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/POI_builder.dart';

//这是一个路径查询的界面，计划是比较自由的，可以任意选途径点和一些个性选项

class PathQueryWidget extends StatefulWidget {
  const PathQueryWidget({super.key});

  @override
  State<PathQueryWidget> createState() => _PathQueryWidgetState();
}

class _PathQueryWidgetState extends State<PathQueryWidget> {
  List<POI> wayPoint=[POI(),POI()];
  int transport=0;
  int strategy=0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          alignment: const Alignment(0,0),
          width:280,
          height:300,
          child: ReorderableListView(
            children: List.generate(wayPoint.length,(index)=>
              Container(
                key:ValueKey(index),
                width:280,
                height:120,
                padding:const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0,),
                child: TextButton(
                  onPressed:(){},
                  style:AppButton.button2,
                  child:SizedBox()//POICard(style:1,poi:wayPoint[index]),
                ),
              )
            ),
            onReorder:(int oldIndex,int newIndex){
              setState((){
                if(oldIndex<newIndex){newIndex-=1;}
                final POI item =wayPoint.removeAt(oldIndex);
                wayPoint.insert(newIndex,item);
              });
            }
          )
        ),
        const SizedBox(height:10),
        SizedBox(
          width:150,
          child: TextButton(
            onPressed:(){setState((){wayPoint.add(POI());});},
            style:AppButton.button1,
            child:const Text("添加途径点"),
          ),
        ),
        //Divider(height:20,thickness: 1,indent:20,endIndent:20,color:AppColors1.primaryColor),
        const SizedBox(height:20),
        Container(
          height:70,
          color:AppColors.primary,
          child:Column(
            children: [
              const Text("出行方式",style:AppText.matter),
              Row(
                children:[
                  transportButton(1,"步行"),
                  transportButton(2,"步行"),
                  transportButton(3,"公交"),
                  transportButton(4,"地铁"),
                  transportButton(5,"驾车"),
                ]
              ),
            ],
          )
        ),
        const SizedBox(height:20),
        Container(
          height:70,
          color:AppColors.primary,
          child:Column(
            children: [
              const Text("策略",style:AppText.matter),
              IndexedStack(
                index:transport,
                children:[
                  Container(),
                  Row(
                    children:[
                      strategyButton(1,"距离最短"),
                      strategyButton(2,"探索小路"),
                      strategyButton(3,"风景不错")
                    ]
                  )
                ]
              ),
            ],
          )
        ),
        const SizedBox(height:30),
        const Text("热门地点",style:AppText.matter),
        SizedBox(
          height:300,
          child: infrestructureList(context)
        )
      ],
    );
  }

  Widget strategyButton(int s,String child){
    return TextButton(
      onPressed:(){setState(() {strategy=s;});},
      style: strategy==s? AppButton.button1 : AppButton.button2,
      child:Text(child),
    );
  }

  Widget transportButton(int t,String child){
    return TextButton(
      onPressed:(){setState(() {transport=t;});},
      style: strategy==t? AppButton.button1 : AppButton.button2,
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
