import 'package:dio/dio.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
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
    print(poiListData.poiList);
    print("发送请求");
    return poiListData.poiList;
  }
}