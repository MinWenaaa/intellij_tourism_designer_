import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/helpers/User.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/helpers/poi_marker_data.dart';
import 'package:intellij_tourism_designer/helpers/record_list_data.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/Iti_data.dart';


enum mapState{
  map(0), detail(1), record(2), view_record(3), view_iti(4), view_event(5);

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

  Future<bool> Signup({required String name, required String password}) async {
    final result = await Api.instance.Signup(name: name, password: password);
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
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng location = LatLng(position.latitude, position.longitude);
      dynamic id = await Api.instance.startRecord(user.uid??200, location);
      rid = id;
      recordLine.add(location);
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

  Future<void> changePoiLayer(int index, bool flag,  {num? radius}) async {

    print("Global.changePoiLayer: poi layer ${index} changes state");
    showPOI[index] = flag;
    markers[index] = [];

    if(flag) {
      print("Global.changePoiLayer: marker list ${index} refresh");
      List<POIMarkerData>? list = await
        Api.instance.getMarkers(
          lastRefreshCenter.longitude - (radius??0.025), lastRefreshCenter.latitude - (radius??0.025),
          lastRefreshCenter.longitude + (radius??0.025), lastRefreshCenter.latitude + (radius??0.025), type: index);
          //print("got point: ${list!.length}");
      list?.forEach((data) =>
        markers[index].add(Marker(
          point: LatLng(data.latitude ?? 0, data.longitude ?? 0),
          child: GestureDetector(
            child: Image.network(ConstantString.poi_icon_url[index], width: 108.r, height: 108.r,),
            onTap: () => markerCallBack(data.pid??0)
          )
        ))
      );

    }
    notifyListeners();

  }

  Future<void> refreshMarker(LatLng newCenter, {num? radius}) async {

    print("Global.refreshMarker: refresh center moved, triggerd refreshment: $newCenter");
    lastRefreshCenter = newCenter;
    for (int i = 0; i < 4; i++) {
      if(!showPOI[i]){
        continue;
      } else {
        markers[i]=[];
        List<POIMarkerData>? list = await
          Api.instance.getMarkers(newCenter.longitude-(radius??0.025), newCenter.latitude-(radius??0.025), newCenter.longitude+(radius??0.025), newCenter.latitude+(radius??0.025), type: i);
          //print("got ${list!.length} point: ${list[0].longitude}");
        list?.forEach((data) => markers[i].add(Marker(
          point: LatLng(data.latitude??0, data.longitude??0),
          child: GestureDetector(
            child: Image.network(ConstantString.poi_icon_url[i], width: 36, height: 36,),
            onTap: () => markerCallBack(data.pid??0)
          )
        )));
      }
    }
    notifyListeners();

  }

  Future<void> markerCallBack(int pid) async {
    print("Global: currentPoi changed ${pid}");
    currentPOI = pid;
    changeState(mapState.detail);
    itiMapCardData = await Api.instance.getMapPOICard(id: pid);
    notifyListeners();
  }




  num rid = 0;
  List<LatLng> recordLine = [];
  List<Marker> recordMarker =[];
  Events currentEvent = Events();

  void changeRid(num id){
    rid = id;
    notifyListeners();
  }

  Future<void> getRecordDetail() async {
    RecordDetail recordDetail = await Api.instance.getRecordDetail(rid);
    recordLine = recordDetail.points??[];
    recordMarker = [];
    recordDetail.events!.forEach((event)=>
      recordMarker.add(Marker(
        width: 160, height: 160,
        point: event.point??LatLng(30, 114),
        child: GestureDetector(
          onTap: () {
            currentEvent = event;
            changeState(mapState.view_event);
          },
          child: Image.network("http://121.41.170.185:5000/user/download/${event.id}.jpg"))))
    );
    notifyListeners();
  }

  void pushPoint(LatLng point){
    recordLine.add(point);
    print(recordLine);
    notifyListeners();
  }

  void pushRecordMarker({required Marker marker}){
    recordMarker.add(marker);
    notifyListeners();
  }





  List<ItiData> itiList = [];
  List<Polyline> planPoints = [];
  List<Marker> planMarker = [];

  Future<void> getPlan({required num id}) async {

    PlanData plan = await Api.instance.readPlanData(id: id);
    plan.itidata?.forEach((itis)=> itiList.addAll(itis));

    print("GlobalModel.getpoint: getPoint");
    planPoints = [];

    LatLng origin = LatLng(itiList.first.y??31, itiList.first.x??114);
    print("Global.getPlan: origin $origin");

    final futures = <Future<void>>[];

    itiList.forEach((iti) {
      planMarker.add(Marker(
        point: LatLng(iti.y??31, iti.x??114),
        child: GestureDetector(
          child: Image.network(ConstantString.poi_icon_url[4], width: 36, height: 36,),
          onTap: (){
            changeState(mapState.detail);
            currentPOI = iti.pid!.toInt();
          },
        )
      ));
      if (iti != itiList.last && iti !=itiList.first) {
        futures.add(
          _fetchNavigationData(origin, LatLng(iti.y??31, iti.x??114)),
        );
        origin = LatLng(iti.y??31, iti.x??114);
        print("Global.getPlan: origin $origin");
      }
    });

    await Future.wait(futures);

    if (this.hasListeners) {
      print("GlobalModel.getpoint : notifyListener");
      changeState(mapState.view_iti);
    }

  }

  Future<void> _fetchNavigationData(LatLng origin, LatLng target) async {
    List<LatLng>? list = await Api.instance.navigationRequire(origin: origin, target: target);
    if (list != null) {
      planPoints.add(planPolyline(list));
      print("PlanEditModel._fetchNavigationData: Get answer of navigation: ${list.last}");
    } else {
      print("PlanEditModel._fetchNavigationData: Navigation response was null.");
    }
  }


  bool mapIndex = true;
  void changeMapIndex(bool value){
    mapIndex = value;
    notifyListeners();
  }

  PoiListViewData? itiMapCardData;





}