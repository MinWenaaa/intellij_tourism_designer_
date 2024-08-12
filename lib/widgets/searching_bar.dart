import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(model.itemList.length,
              (index)=>Builder(builder: (context) => _searchItem(context, model.itemList[index]!, model.itemList.length-1==index),
                
              )
            )
          )
        )
      ),
    );
  }

  Widget _searchItem(BuildContext context, SearchItemData item, bool isLast){
    return Column(
      children: [
        InkWell(
          onTap: (){
            widget.callBack.call(LatLng(item.y??30.5, item.x??114.2), 16.5);
            FloatingSearchBar.of(context)?.close();
          },
          child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Icon(Icons.place, key: Key('place')),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(item.pname??"",maxLines: 1,),
                      const SizedBox(height: 2),
                      Text(item.pintroduceShort??"",maxLines: 1,),
                      const SizedBox(height: 2),
                      Text(item.paddress??"",maxLines: 1,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if(!isLast) Divider(height: 0,)
      ],
    );
  }
}

