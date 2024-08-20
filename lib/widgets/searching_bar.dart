import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/search_result_data.dart';
import 'package:intellij_tourism_designer/models/search_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';

/*
 地图页面搜索栏
 */

class SearchingBar extends StatefulWidget {
  
  Function(LatLng, double) callBack;
  SearchingBar({required this.callBack, super.key});

  @override
  State<SearchingBar> createState() => _SearchingBarState();
}

class _SearchingBarState extends State<SearchingBar> {
  
  SearchModel searchModel = SearchModel();
  final FloatingSearchBarController controller = FloatingSearchBarController();

  String type = ConstantString.poi[0];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchModel>(
      create: (context) => searchModel,
      child: Consumer<SearchModel>(
        builder: (BuildContext context, SearchModel model, child){
          return FloatingSearchBar(
            hint: "Search...",
            controller: controller,
            transitionDuration: const Duration(milliseconds: 800),
            actions: _actions(),
            progress: model.isLoadding,
            onQueryChanged: (query)=>model.onQueryChanged(type: "旅游景点", keyword: query),
            builder: (BuildContext context, _) => _buildExpandableBody(model, context),
            onKeyEvent: (KeyEvent keyEvent) {
              if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
                controller.query = '';
                controller.close();
              }
            },
          );
        },
      ),
    );
  }

  List<FloatingSearchBarAction> _actions(){
    return [
      FloatingSearchBarAction(
        child: CircularButton(
          icon: const Icon(Icons.place),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ];
  }

  Widget _buildExpandableBody(SearchModel model, BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 42.h),
      child: Material(
        elevation: 16.r,
        borderRadius: BorderRadius.circular(20.r),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 42.w),
          child: Column(
            children: List.generate(model.itemList.length, (index)=>Builder(
              builder: (context) => _searchItem(context, model.itemList[index]!, model.itemList.length-1==index),
              )
            )
          )
        )
      ),
    );
  }

  Widget _searchItem(BuildContext context, SearchItemData item, bool isLast){
    return SizedBox(
      height: 240.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 20.h),
            child: InkWell(
              onTap: (){
                widget.callBack.call(LatLng(item.y??30.5, item.x??114.2), 16.5);
                FloatingSearchBar.of(context)?.close();
              },
              child: Row(
                children: [
                  Icon(Icons.place, key: const Key('place'), size: 84.r,),
                  SizedBox(width: 64.h),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.pname??"",maxLines: 1, style: AppText.Head2,),
                        SizedBox(height: 5.h),
                        Text(item.pintroduceShort??"",maxLines: 1, style: AppText.matter,),
                        SizedBox(height: 5.h),
                        Text(item.paddress??"",maxLines: 1, style: AppText.detail,),
                       ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
          if(!isLast) const Divider(height: 0,)
        ],
      ),
    );
  }
}

