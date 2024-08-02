import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/Constants.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/models/home_view_model.dart';
import 'package:intellij_tourism_designer/pages/mobile/POIDetailPage.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../helpers/POI_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel viewModel = HomeViewModel();
  RefreshController refreshController = RefreshController();

  String type = POItype.attraction;

  @override
  void initState(){
    super.initState();
    viewModel.loadListData(type);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context){return viewModel;},
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _typeItem(tartgetType: POItype.attraction, color: Colors.amberAccent, text: "景点"),
                _typeItem(tartgetType: POItype.dining, color: Colors.amberAccent, text: "餐饮"),
                _typeItem(tartgetType: POItype.hotel, color: Colors.amberAccent, text: "住宿"),
                _typeItem(tartgetType: POItype.camera, color: Colors.amberAccent, text: "机位"),
              ],
            ),
            SizedBox(height:10),
            _ListView()
          ],
        ),
      ),
    );
  }


  Widget _typeItem({String? tartgetType, Color? color, String? text}){
    return GestureDetector(
      onTap: (){
        type = tartgetType ?? POItype.attraction;
        setState(() {});
      },
      child: Container(
        width: 56, height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: color ?? Colors.white
        ),
        child: Text(text??""),
      ),
    );
  }

  Widget _ListView() {
    return Consumer<HomeViewModel>(builder: (context, vm, child) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: vm.listData?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              RouteUtils.push(context, Poidetailpage());
            },
            child: _ListViewItem(vm.listData?[index]),
          );
        });
    });
  }

  Widget _ListViewItem(PoiListViewData? poi){
    return Container(
        width: double.infinity, height: 120,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12,width:0.5),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                children: [
                  Text(poi?.pname ?? ""),
                  Text(poi?.paddress ?? "",
                    overflow: TextOverflow.clip, // 裁剪超出部分
                    maxLines: 2,
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Image.network(
                "https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp",
                fit: BoxFit.cover,

              )
            )
          ],
        )
      );
    }

}
