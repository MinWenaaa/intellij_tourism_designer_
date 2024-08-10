import 'package:dio/dio.dart';
import 'package:intellij_tourism_designer/helpers/comment_list.dart';
import 'package:intellij_tourism_designer/helpers/navigation_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_detail_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/helpers/search_result_data.dart';
import 'package:latlong2/latlong.dart';
import 'dio_instance.dart';

class Api {
  static Api instance = Api._();

  Api._();


  Future<List<PoiListViewData>?> getPOIList(String type, int count) async{
    Response response = await Dio_ours.instance().get(
        path: "/feature/homepage",
        queryParameters: {"type": type, "i": count}
    );
    PoiListData poiListData = PoiListData.fromJson(response.data);
    return poiListData.poiList;
  }


  Future<PoiDetail?> getPoiDetail(num id) async{
    Response response = await Dio_ours.instance().get(
      path: "/feature/detail",
      queryParameters: {"id": id}
    );
    return PoiDetail.fromJson(response.data);
  }


  Future<List<CommentData>?> getCommentList(num id) async{
    Response response = await Dio_ours.instance().get(
        path: "/feature/comments",
        queryParameters: {"id": id}
    );
    CommentListData commnetListData = CommentListData.fromJson(response.data);
    return commnetListData.listData;
  }



  Future<List<SearchItemData?>?> Search({required String keyword, required String type}) async {
    Response response = await Dio_ours.instance().get(
      path: "/feature/search",
      queryParameters: {"name": keyword, "type": type}
    );
    SearchListData searchListData = SearchListData.fromJson(response.data);
    return searchListData.itemList;
  }


  Future<List<LatLng>?> navigationRequire({required LatLng origin, required LatLng target}) async{

    print("require navigation: origin${origin}, target:${target}");

    Response response = await Dio_gaode.instance().get(
      path: "/direction/walking",
      queryParameters: {
        "origin": "${origin.longitude},${origin.latitude}",
        "destination": "${target.longitude},${target.latitude}",
        "key": "3a1ca59e1a7cde051a8875cc0aa9e2a6",
      }
    );

    NavigationData navigationdata = NavigationData.fromJson(response);
    return navigationdata.getPointList();

  }
  
}