import 'package:dio/dio.dart';
import 'package:intellij_tourism_designer/helpers/comment_list.dart';
import 'package:intellij_tourism_designer/helpers/navigation_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_detail_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/helpers/search_result_data.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/User.dart';
import '../helpers/weather_data.dart';
import 'dio_instance.dart';

class Api {
  static Api instance = Api._();

  Api._();


  //登录
  Future<User?> UserLogin(
      {required String name, required String password}) async{
    Response response = await Dio_database.instance().get(
        path: "user/login",
        queryParameters: {"name": name, "password": password}
    );
    User user = User.fromJson(response.data);
    return user;
  }

  //获取POI列表
  Future<List<PoiListViewData>?> getPOIList(String type, int count) async{
    Response response = await Dio_database.instance().get(
        path: "feature/homepage",
        queryParameters: {"type": type, "i": count}
    );
    PoiListData poiListData = PoiListData.fromJson(response.data);
    return poiListData.poiList;
  }

  //获取POI详细信息
  Future<PoiDetail?> getPoiDetail(num id) async{
    Response response = await Dio_database.instance().get(
      path: "feature/detail",
      queryParameters: {"id": id}
    );
    return PoiDetail.fromJson(response.data);
  }

  //获取评论列表
  Future<List<CommentData>?> getCommentList(num id) async{
    Response response = await Dio_database.instance().get(
        path: "feature/comments",
        queryParameters: {"id": id}
    );
    CommentListData commnetListData = CommentListData.fromJson(response.data);
    return commnetListData.listData;
  }


  //获取搜索结果
  Future<List<SearchItemData?>?> Search({required String keyword, required String type}) async {
    Response response = await Dio_database.instance().get(
      path: "feature/search",
      queryParameters: {"name": keyword, "type": type}
    );
    SearchListData searchListData = SearchListData.fromJson(response.data);
    return searchListData.itemList;
  }

  //获取导航信息
  Future<List<LatLng>?> navigationRequire({required LatLng origin, required LatLng target}) async{

    print("require navigation: origin${origin.longitude},${origin.latitude}, ${target.longitude},${target.latitude}");

    Response response = await Dio_database.instance().get(
      path: "designer/navigation",
      queryParameters: {
        "origin": "${origin.longitude},${origin.latitude}",
        "destination": "${target.longitude},${target.latitude}",
      },
    );
    print("navigation request success");
    NavigationData navigationData = NavigationData.fromJson(response.data);
    return navigationData.getPointList();

  }

  //根据用户id获取规划列表

  //根据用户id获取回忆列表

  //获取规划详细信息

  //获取回忆详细信息

  //获取天气数据
  Future<WeatherData?> getWeather({required LatLng location}) async {
    Response response1 = await Dio_qw.instance().get(
        path: "weather/now",
        queryParameters: {
          "location": "${location.longitude},${location.latitude}",
          "key": "5d778ca0412d4b599fd38ff17c043786",
        }
    );
    print("weather data get: ${response1}");

    Response response2 = await Dio_qw.instance().get(
        path: "astronomy/sun",
        queryParameters: {
          "location": "${location.longitude},${location.latitude}",
          "date": "20240815",
          "key": "5d778ca0412d4b599fd38ff17c043786",
        }
    );
    print("sun data get: ${response2}");

    WeatherData weatherData = WeatherData.fromJson(response1.data);
    Sun sun = Sun.fromJson(response2.data);
    weatherData.sunrise = sun.sunrise;
    weatherData.sunset = sun.sunset;

    return weatherData;
  }

}