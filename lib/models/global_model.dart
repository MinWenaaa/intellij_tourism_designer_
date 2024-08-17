import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/helpers/User.dart';
import 'package:intellij_tourism_designer/helpers/poi_marker_data.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';


enum mapState{
  map(0), detail(1), record(2), view_record(3), view_iti(4);

  final int intValue;

  const mapState(this.intValue);
}

class GlobalModel with ChangeNotifier{



  User user = User(
    uid: 0,
    unickname: "未登录",
    upic: "https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp"
  );

  Future<bool> Login({required String name, required String password}) async {
    final result = await Api.instance.UserLogin(name: name, password: password);
    if (result == null) {
      return false;
    } else {
      user = result;
      return true;
    }
  }





  int baseProvider = 0;
  mapState state = mapState.map;

  void changeBaseLayer(int provider){
    baseProvider = provider;
    notifyListeners();
  }

  Future<void> changeState(mapState newState) async {
    state = newState;
    //发送新建记录请求
    if(state==mapState.record){
      dynamic id = await Api.instance.startRecord(user.uid??200, lastRefreshCenter);
      rid = id;
      print("record ${id} start!");
    }
    notifyListeners();
  }




  int showSunset = -1;
  List<bool> showPOI = [false, false, false, false];
  List<bool> showHeatMap = [false, false, false, false];
  List<bool> showFeatureMap = [false, false, false, false, false];

  LatLng lastRefreshCenter = const LatLng(30.5,114.4);
  List<List<Marker>> markers = [[],[],[],[]];
  int currentPOI = -1;

  void changeSunset(int i){
    showSunset = i;
    notifyListeners();
  }
  void changeHeatMap(int index, bool value){
    showHeatMap[index] = value;
    notifyListeners();
  }
  void changeFeature(int index, bool value){
    showFeatureMap[index] = value;
    notifyListeners();
  }

  Future<void> changePoiLayer(int index, bool flag) async {

    print("poi layer ${index} changes state");
    showPOI[index] = flag;
    markers[index] = [];

    if(flag) {
      print("marker list ${index} refresh");
      List<POIMarkerData>? list = await
        Api.instance.getMarkers(
          lastRefreshCenter.longitude - 0.025, lastRefreshCenter.latitude - 0.025,
          lastRefreshCenter.longitude + 0.025, lastRefreshCenter.latitude + 0.025, type: index);
          //print("got point: ${list!.length}");
      list?.forEach((data) =>
        markers[index].add(Marker(
          point: LatLng(data.latitude ?? 0, data.longitude ?? 0),
          child: GestureDetector(
            child: Image.network(ConstantString.poi_icon_url[index], width: 32, height: 32,),
            onTap: (){
              currentPOI = data.pid??0;
              changeState(mapState.detail);
            },
          )
        ))
      );

    }
    notifyListeners();

  }

  Future<void> refreshMarker(LatLng newCenter) async {

    print("refresh center moved, triggerd refreshment");
    lastRefreshCenter = newCenter;
    for (int i = 0; i < 4; i++) {
      if(!showPOI[i]){
        continue;
      } else {
        markers[i]=[];
        List<POIMarkerData>? list = await
          Api.instance.getMarkers(newCenter.longitude-0.025, newCenter.latitude-0.025, newCenter.longitude+0.025, newCenter.longitude+0.025, type: i);
          //print("got ${list!.length} point: ${list[0].longitude}");
        list?.forEach((data) => markers[i].add(Marker(
          point: LatLng(data.latitude??0, data.longitude??0),
          child: GestureDetector(
            child: Image.network(ConstantString.poi_icon_url[i]),
            onTap: (){
              currentPOI = data.pid??0;
              changeState(mapState.detail);
            },
          )
        )));
      }
    }
    notifyListeners();

  }




  num rid = 0;
  List<LatLng> currentRecords = [];


  void setCurrentRecords(List<LatLng> list){
    currentRecords = list;
    notifyListeners();
  }




}