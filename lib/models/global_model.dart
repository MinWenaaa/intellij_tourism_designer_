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
  int currentPOI = 0;
  num rid = 0;

  List<bool> thematicMap = [false];

  LatLng lastRefreshCenter = const LatLng(30.5,114.4);
  List<bool> isShowPOI = [false, false, false, false];
  List<List<Marker>> markers = [[],[],[],[]];

  List<LatLng> currentRecords = [];

  void changeBaseLayer(int provider){
    baseProvider = provider;
    notifyListeners();
  }

  Future<void> changeState(mapState newState) async {
    state = newState;
    if(state==mapState.record){
      dynamic id = await Api.instance.startRecord(user.uid??200, center);
      rid = id;
      print("record ${id} start!");
    }
    notifyListeners();
  }

  Future<void> changePoiMarkerShowState(int index, bool flag) async {

    print("poi layer ${index} changes state");
    isShowPOI[index] = flag;

    if(flag) {
      for (int i = 0; i < 4; i++) {
        if (!isShowPOI[i]) {
          continue;
        } else {
          markers[i] = [];
          print("marker list ${index} refresh");
          List<POIMarkerData>? list = await
          Api.instance.getMarkers(
              lastRefreshCenter.longitude - 0.05, lastRefreshCenter.latitude - 0.05,
              lastRefreshCenter.longitude + 0.05, lastRefreshCenter.longitude + 0.05, type: i);
          print("got point: ${list?[0]}");
          list?.forEach((data) =>
              markers[i].add(Marker(
                  point: LatLng(data.latitude ?? 0, data.longitude ?? 0),
                  child: GestureDetector(
                    child: Image.network(ConstantString.poi_icon_url[i], width: 32, height: 32,),
                    onTap: (){
                      currentPOI = data.pid??0;
                      changeState(mapState.detail);
                    },
                  )
              )
           ));
        }
      }
    }else{
      markers[index] = [];
    }
    notifyListeners();
  }

  Future<void> refreshMarker(LatLng newCenter) async {

    if( (lastRefreshCenter.latitude - newCenter.latitude).abs() < 0.05 &&
        (lastRefreshCenter.longitude - newCenter.longitude).abs() <0.05 ) {
      print("distance is not far enough to trigger refreshment");
      return;
    } else {

      print("refresh center moved, triggerd refreshment");
      lastRefreshCenter = newCenter;
      for (int i = 0; i < 4; i++) {
        if(!isShowPOI[i]){
          continue;
        } else {
          markers[i]=[];
          List<POIMarkerData>? list = await
            Api.instance.getMarkers(newCenter.longitude-0.05, newCenter.latitude-0.05, newCenter.longitude+0.05, newCenter.longitude+0.05, type: i);
          print("got ${list!.length} point: ${list?[0].longitude}");
          list?.forEach((data) => markers[i].add(Marker(
              point: LatLng(data.latitude??0, data.longitude??0),
              child: GestureDetector(
                child: Image.network(ConstantString.poi_icon_url[i]),
                onTap: (){
                  currentPOI = data.pid??0;
                  changeState(mapState.detail);
                },
              )
            )
          ));
        }
      }
    }
    notifyListeners();
  }

  void setCurrentRecords(List<LatLng> list){
    currentRecords = list;
    notifyListeners();
  }




  LatLng center = const LatLng(30.6,114.3);

  void changeCenter(LatLng newCenter){
    center = newCenter;
    notifyListeners();
  }



}