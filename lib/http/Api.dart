import 'package:dio/dio.dart';
import 'package:intellij_tourism_designer/helpers/comment_list.dart';
import 'package:intellij_tourism_designer/helpers/poi_detail_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/helpers/search_result_data.dart';
import 'dio_instance.dart';

class Api {
  static Api instance = Api._();

  Api._();


  Future<List<PoiListViewData>?> getPOIList(String type, int count) async{
    Response response = await DioInstance.instance().get(
        path: "/feature/homepage",
        queryParameters: {"type": type, "i": count}
    );
    PoiListData poiListData = PoiListData.fromJson(response.data);
    return poiListData.poiList;
  }


  Future<PoiDetail?> getPoiDetail(num id) async{
    Response response = await DioInstance.instance().get(
      path: "/feature/detail",
      queryParameters: {"id": id}
    );
    return PoiDetail.fromJson(response.data);
  }


  Future<List<CommentData>?> getCommentList(num id) async{
    Response response = await DioInstance.instance().get(
        path: "/feature/comments",
        queryParameters: {"id": id}
    );
    CommentListData commnetListData = CommentListData.fromJson(response.data);
    return commnetListData.listData;
  }



  Future<List<SearchItemData?>?> Search({required String keyword, required String type}) async {
    Response response = await DioInstance.instance().get(
      path: "/feature/search",
      queryParameters: {"name": keyword, "type": type}
    );
    SearchListData searchListData = SearchListData.fromJson(response.data);
    return searchListData.itemList;
  }

}