import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/data_model.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/helpers/POI_builder.dart';
import 'package:intellij_tourism_designer/helpers/itinerary_builder.dart';

//细节信息的展示卡片
class POICard extends StatelessWidget {
  final int style;
  final POI poi;

  const POICard({required this.style,required this.poi,super.key});

  @override
  Widget build(BuildContext context) {
    switch(style){
      case 0:
        return _poiCard1(context);
      case 1:
        return _poiCard2(context);
      default:
        return Container();
    }
  }

  Widget _poiCard1(BuildContext context){
    return Row(
        children:[
          Flexible(
            flex:5,
            child: Column(
                children:<Widget>[
                  Row(
                      children:<Widget>[
                        const Icon(Icons.ice_skating),
                        Text(poi.Name),
                        TextButton(
                          onPressed:(){
                            Provider.of<ShareDataPage>(context, listen: false).changePOI(poi);
                            Provider.of<ShareDataPage>(context, listen: false).changeDetailed(true);
                          },
                          style:AppButton.button1,
                          child:const Icon(Icons.add),
                        )
                      ]
                  ),
                  Text(poi.info),
                  Text(poi.location)
                ]
            ),
          ),
          Flexible(
            flex:4,
            child: Image(image: AssetImage(poi.ImageURL)),
          )
        ]
    );
  }
  Widget _poiCard2(BuildContext context) {
    return Row(
      children:<Widget>[
        Flexible(
          flex:3,
          child: Column(
            children:<Widget>[
              Row(
                children:<Widget>[
                  const Icon(Icons.ice_skating),
                  Text(poi.Name)
                ]
              ),
              Text(poi.info)
            ]
          ),
        ),
        Flexible(
          flex:2,
          child: Image(image: AssetImage(poi.ImageURL))
        ),
      ]
    );
  }
}


class POIDetailedView extends StatefulWidget {
  final List<Comment> comments=[];
  final POI poi;

  POIDetailedView({required this.poi, List<Comment>? comments, super.key}){
    comments=comments??[sampleCon,sampleCon,sampleCon,sampleCon];
  }

  @override
  State<POIDetailedView> createState() => _POIDetailedViewState();
}

class _POIDetailedViewState extends State<POIDetailedView> {
  late final POI poi = widget.poi;
  late final List<Comment> comments = widget.comments;

  _POIDetailedViewState();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height:1),
          Image(image: AssetImage(poi.ImageURL)),
          SizedBox(
            height:AppSize.imgHeight1,
            child: ListView(
              children:<Widget>[
                Row(
                  children:<Widget>[
                    const Icon(Icons.ice_skating),
                    Text(poi.Name)
                  ]
                ),
                //Text(_facility["info"]),
                const Text("评分"),
                const Text(""),
                const Divider(color:AppColors1.primaryColor, height:50, thickness:3, indent:30, endIndent:30),
                TextButton(
                  onPressed:(){setState(() {comments.add(sampleCon);});},
                  style:AppButton.button2,
                  child:const Icon(Icons.add),
                ),
                SizedBox(
                  height:300,
                  child:ListView(
                    children:List.generate(comments.length,(index)=>
                      Column(
                        children:[
                          Text(comments[index].userName,style:AppText.standard),
                          Text(comments[index].content,style:AppText.standard)
                        ]
                      )
                    )
                  )
                )
              ]
            ),
          )
        ]
    );
  }
}


class ItiCard1 extends StatelessWidget {
  final Itinerary curIti;
  const ItiCard1({required this.curIti,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        Flexible(
          flex:3,
          child: Column(
            children:[
              Text(curIti.name,style:AppText.small),
              const Text("时间",style:AppText.small),
            ]
          ),
        ),
        Flexible(
        flex:2,
        child: Image(image: AssetImage(curIti.imageURLs[0]))
        )
      ]
    );
  }
}

class ActCard extends StatelessWidget {
  final Activity curAct;
  const ActCard({required this.curAct,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        Flexible(
          flex:3,
          child:Column(
            children:[
              Row(
                children:[
                  const Icon(Icons.abc),
                  Text(curAct.point.Name,style:AppText.small),
                ]
              ),
              const Text("时间：",style:AppText.small)
            ]
          )
        ),
        Flexible(
          flex:2,
          child:Image(image: AssetImage(curAct.point.ImageURL))
        ),
      ]
    );
  }
}



class WeatherCard extends StatelessWidget {
  final Weather curWea;
  const WeatherCard({required this.curWea,super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children:[
        Flexible(
          flex:5,
          child:Column(
            children: [
              Text('时间：????-??-??',style:AppText.small),
              Card(
                surfaceTintColor:AppColors1.primaryColor,
                child:Text("天气：         温度：           ",style:AppText.pStandard),
              )
            ]
          )
        ),
        Flexible(
          flex:3,
          child:Icon(Icons.sunny,size:50)
        )
      ]
    );
  }
}
