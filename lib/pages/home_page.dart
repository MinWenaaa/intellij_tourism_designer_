import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/home_view_model.dart';
import 'package:intellij_tourism_designer/pages/poi_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../constants/constants.dart';
import '../widgets/detail_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeViewModel viewModel = HomeViewModel();
  final RefreshController refreshController = RefreshController();

  String type = ConstantString.attraction;
  bool is_detail = false;
  int currentID = 0;


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
          Column(
            children: [
              _Head(),
              SizedBox(height: 16.h,),
              Container(
                height: 1700.h,
                child: SmartRefresher(
                  controller: refreshController,
                  enablePullUp: true,
                  enablePullDown: true,
                  header: const ClassicHeader(),
                  footer: const ClassicFooter(),
                  onLoading: () => LoadMore(),
                  onRefresh: () => Refresh(),
                  child: SingleChildScrollView(
                    child: _ListView()
                    ),
                ),
              ),
            ],
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

  Widget _Head(){
    return Container(
      height: 430.h,
      color: AppColors.highlight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 40.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _typeItem(tartgetType: ConstantString.attraction, text: "景点"),
              _typeItem(tartgetType: ConstantString.dining, text: "餐饮"),
              _typeItem(tartgetType: ConstantString.hotel, text: "住宿"),
              _typeItem(tartgetType: ConstantString.camera, text: "机位"),
            ],
          ),
          SizedBox(height:10.h),
          Divider(height: 2.6.h, color: Colors.black12,),
          Row(
            children: [
              SizedBox(width: 48.w,),
              Text("最热", style: AppText.Head1,),
              Expanded(child: SizedBox()),
              Text("最新", style: AppText.Head1,),
              Expanded(child: SizedBox()),
              Text("最近", style: AppText.Head1,),
              SizedBox(width: 48.w,)
            ],
          ),
          Divider(height: 2.6.h, color: Colors.black12,),
        ],
      ),
    );
  }

  Widget _typeItem({required String tartgetType, required String text}){
    return GestureDetector(
      onTap: () => setState(() {
        type = tartgetType;
        viewModel.loadListData(type: type, isLoadMore: false);
      }),
      child: Column(
        children: [
          Image.network(ConstantString.homePageIcon[tartgetType]![tartgetType==type ? 0:1], width: 180.r, height: 180.h,),
          Text(text, style: tartgetType==type ? AppText.Head2:AppText.detail,)
        ],
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
              is_detail = true;
              currentID = vm.listData?[index].pid??1;
              setState(() {});
            },
            child: POIListItem(poi: vm.listData![index],height: 320.h,)
          );
        });
    });
  }

}
