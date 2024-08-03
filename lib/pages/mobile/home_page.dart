import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intellij_tourism_designer/constants/Constants.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/models/home_view_model.dart';
import 'package:intellij_tourism_designer/pages/mobile/POIDetailPage.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    viewModel.loadListData(type: type, isLoadMore: false);
  }

  void Refresh(){
    viewModel.loadListData(type: type, isLoadMore: false).then((value){
      refreshController.refreshCompleted();
    });
  }

  void LoadMore(){
    viewModel.loadListData(type: type, isLoadMore: true).then((value){
      refreshController.loadComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context){return viewModel;},
      child: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        onLoading: (){ LoadMore(); },
        onRefresh: (){ Refresh(); },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _typeItem(tartgetType: POItype.attraction, color: Colors.amberAccent, text: "景点"),
                  _typeItem(tartgetType: POItype.dining, color: Colors.amberAccent, text: "餐饮"),
                  _typeItem(tartgetType: POItype.hotel, color: Colors.amberAccent, text: "住宿"),
                  _typeItem(tartgetType: POItype.camera, color: Colors.amberAccent, text: "机位"),
                ],
              ),
              const SizedBox(height:10),
              const Divider(height: 1, color: Colors.black12,),
              const SizedBox(height:10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("最热"),
                  Text("最新"),
                  Text("最近")
                ],
              ),
              const SizedBox(height:10),
              const Divider(height: 1, color: Colors.black12,),
              _ListView()
            ],
          ),
        ),
      ),
    );
  }


  Widget _typeItem({required String tartgetType, required String text, Color? color}){
    return GestureDetector(
      onTap: (){
        type = tartgetType;
        viewModel.loadListData(type: type, isLoadMore: false);
        setState(() {});
      },
      child: Container(
        width: 56, height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: color ?? Colors.white
        ),
        child: Text(text),
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
            onTap: () async {
              RouteUtils.push(context, Poidetailpage(id: vm.listData![index].pid??1));
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
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
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
              child: Image.network(poi?.pphoto ??
                "https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp",
                fit: BoxFit.cover,
                width: double.infinity, height: double.infinity,
              )
            )
          ],
        )
      );
    }

}
