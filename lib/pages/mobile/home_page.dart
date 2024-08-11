import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/Constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/models/home_view_model.dart';
import 'package:intellij_tourism_designer/pages/mobile/poi_detail_page.dart';
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
  bool is_detail = false;
  num currentID = 0;


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
      create: (context) => viewModel,
      child: Stack(
        children: [
          SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            enablePullDown: true,
            header: const ClassicHeader(),
            footer: const ClassicFooter(),
            onLoading: () => LoadMore(),
            onRefresh: () => Refresh(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height:10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("最热", style: AppText.matter,),
                      Text("最新", style: AppText.matter,),
                      Text("最近", style: AppText.matter,),
                    ],
                  ),
                  const SizedBox(height:10),
                  const Divider(height: 1, color: Colors.black12,),
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
                  _ListView()
                ],
              ),
            ),
          ),
          is_detail ? Poidetailpage(id: currentID): const SizedBox(),
          is_detail ? Positioned(
            top: 10, left: 10,
            child: GestureDetector(
              onTap: () {
                is_detail = false;
                setState((){});
              },
              child: Icon(Icons.arrow_back_ios, color: AppColors.matter,)),
            )  : const SizedBox()

        ],
      ),
    );
  }


  Widget _typeItem({required String tartgetType, required String text, Color? color}){
    return tartgetType==type ? primaryInkWell(
      callback: (){
        type = tartgetType;
        viewModel.loadListData(type: type, isLoadMore: false);
        setState(() {});
      },
      text: text,
      width: 84, height: 60,
    ) : secondaryInkWell(
      callback: (){
        type = tartgetType;
        viewModel.loadListData(type: type, isLoadMore: false);
        setState(() {});
      },
      text: text,
      width: 84, height: 60,
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
              is_detail = true;
              currentID = vm.listData?[index].pid??1;
              setState(() {});
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
          border: Border.all(color: AppColors.detail, width:0.5),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(poi?.pname ?? "", style: AppText.Head2,),
                    Text(poi?.pintroduceShort ?? "",
                      overflow: TextOverflow.clip, // 裁剪超出部分
                      maxLines: 2,
                      style: AppText.matter,),
                    Text(poi?.paddress ?? "",
                      overflow: TextOverflow.clip, // 裁剪超出部分
                      maxLines: 1,
                      style: AppText.detail,
                    )
                  ],
                ),
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
