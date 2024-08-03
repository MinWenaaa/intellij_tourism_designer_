import 'package:flutter/cupertino.dart';
import 'package:intellij_tourism_designer/helpers/comment_list.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import '../helpers/poi_detail_data.dart';
import '../http/Api.dart';

class HomeViewModel with ChangeNotifier{
  int loadCount=1;
  List<PoiListViewData>? listData;

  Future loadListData(
      {required String type, required bool isLoadMore}) async{

    isLoadMore ? loadCount++ : loadCount=1;

    await Api.instance.getPOIList(type, loadCount).then((value){
      if(isLoadMore){
        listData?.addAll(value??[]);
      }else{
        listData = value;
      }
    });

    notifyListeners();
  }
}



class POIDetialViewModel with ChangeNotifier{
  PoiDetail? poi;
  List<CommentData>? commentList;

  Future getPoi({required num id}) async {
    poi = await Api.instance.getPoiDetail(id);
    notifyListeners();
  }

  Future getComment({required num id}) async {
    commentList = await Api.instance.getCommentList(id);
    notifyListeners();
  }

}