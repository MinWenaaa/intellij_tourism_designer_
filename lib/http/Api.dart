import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intellij_tourism_designer/helpers/record_list_data.dart';
import 'package:intl/intl.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/helpers/comment_list.dart';
import 'package:intellij_tourism_designer/helpers/navigation_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_detail_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_marker_data.dart';
import 'package:intellij_tourism_designer/helpers/search_result_data.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/Iti_data.dart';
import '../helpers/User.dart';
import '../helpers/weather_data.dart';
import 'dio_instance.dart';

class Api {
  static Api instance = Api._();

  Api._();


  //登录
  Future<User?> UserLogin({required String name, required String password}) async{
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

    Response response = await Dio_gaode.instance().get(
      path: "direction/walking",
      queryParameters: {
        "origin": "${origin.longitude},${origin.latitude}",
        "destination": "${target.longitude},${target.latitude}",
        "key": "3a1ca59e1a7cde051a8875cc0aa9e2a6"
      },
    );
    print("navigation request success");
    NavigationData navigationData = NavigationData.fromJson(response.data);
    return navigationData.getPointList();

  }

  //根据用户id获取规划列表

  //根据用户id获取回忆列表
  Future<List<RecordListViewData>?> getRecordList(num uid) async {
    Response response = await Dio_database.instance().get(
      path: "user/records",
      queryParameters: {"id": uid}
    );
    print("get user: $uid 's records");
    RecordListData recordListData = RecordListData.fromJson(response.data);
    return recordListData.recordList;
  }

  //获取规划详细信息

  //获取回忆详细信息

  //获取天气数据
  Future<WeatherData?> getWeather({required LatLng location, required DateTime date}) async {

    Response response1 = await Dio_qw.instance().get(
        path: "weather/now",
        queryParameters: {
          "location": "${location.longitude},${location.latitude}",
          "key": "5d778ca0412d4b599fd38ff17c043786",
        }
    );
    //print("weather data get: ${response1}");

    //print("${currentTime.year}${currentTime.month}${currentTime.day}");
    Response response2 = await Dio_qw.instance().get(
        path: "astronomy/sun",
        queryParameters: {
          "location": "${location.longitude},${location.latitude}",
          "date": "${date.year}0${date.month}${date.day}",
          "key": "5d778ca0412d4b599fd38ff17c043786",
        }
    );
    //print("sun data get: ${response2}");

    WeatherData weatherData = WeatherData.fromJson(response1.data);
    Sun sun = Sun.fromJson(response2.data);
    weatherData.sunrise = sun.sunrise;
    weatherData.sunset = sun.sunset;

    return weatherData;
  }


  //poi_marker刷新
  Future<List<POIMarkerData>?> getMarkers(double min_x, double min_y, double max_x, double max_y, {required int type}) async{

    Response response = await Dio_enterprise.instance().get(
      path: "geoserver/Esri_c657/wfs",
      queryParameters: {
        "request": "GetFeature",
        "typename": ConstantString.poi_layer[type],
        "outputFormat": "json",
        "bbox": "${min_x},${min_y},${max_x},${max_y},EPSG:4326",
        "count": 200,
      },
    );

    print("request marker refresh: ${min_x},${min_y},${max_x},${max_y}");
    PoiMarkerListData poiMarkerData = PoiMarkerListData.fromJson(response.data);

    return poiMarkerData.getPoiList();

  }

  //新建记录
  Future<num?> startRecord(num uid, LatLng start) async {
    DateTime currentTime = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    Response response = await Dio_database.instance().post(
      path: "designer/create_record",
      data: {
        "id": uid,
        "start": "${start.longitude},${start.latitude}",
        "name": formatter.format(currentTime)
      }
    );
    print("record name: ${formatter.format(currentTime)}");
    return response.data['id'];
  }
  //刷新点
  Future<void> pushPoint(num rid, LatLng point) async {
    Response response = await Dio_database.instance().post(
      path: "designer/push_point",
      data: {
        "id": rid,
        "point": "${point.longitude},${point.latitude}"
      }
    );
  }


  //获取模型规划
  Future<List<List<ItiData>>?> design_LLM({required num poinNum, required String requirement}) async {
    Response response = await Dio_database.instance().post(
      path: "designer/designer",
      data: {"num": poinNum, "requirement": requirement}
    );
    //print("api got result");
    ItiListData planData = ItiListData.fromJson(response.data);
    //print("result turned into: ${planData}");
    return planData.itiList;
  }

}