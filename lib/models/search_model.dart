import 'package:flutter/widgets.dart';
import '../helpers/search_result_data.dart';
import '../http/Api.dart';

class SearchModel with ChangeNotifier{

  bool isLoadding = false;
  List<SearchItemData?> itemList = history;
  String query = '';

  Future<void> onQueryChanged(
      {required String type, required String keyword}) async{

    if(keyword==query){
      return;
    }

    query = keyword;
    isLoadding = true;
    notifyListeners();

    if(keyword.isEmpty){
      itemList = history;
    }else{
      await Api.instance.Search(keyword: keyword, type: type).then((value){
        itemList = value!;
      });
    }

    isLoadding = false;
    notifyListeners();

  }

  void clear(){
    itemList = history;
    notifyListeners();
  }

}

List<SearchItemData> history = <SearchItemData>[
  SearchItemData(
    pintroduceShort:  "学习农民运动史的课堂",
    paddress: "武昌红巷13号",
    pname: "中央农民运动讲习所",
  ),
  SearchItemData(
    pintroduceShort:  "百年商业街品建筑扫尖货",
    paddress: "武汉市江汉区江汉路",
    pname:  "江汉路步行街",
  ),
  SearchItemData(
    pintroduceShort: null,
    paddress: "马场路138号",
    pname: "武汉瑞安海龙酒店(汉口火车站店)",
  ),
];