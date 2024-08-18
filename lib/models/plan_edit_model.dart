import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/helpers/Iti_data.dart';
import 'package:latlong2/latlong.dart';
import '../constants/Markers.dart';
import '../http/Api.dart';

class PlanEditModel with ChangeNotifier{

  DateTime start = DateTime.now();
  int numDays = 0;
  String requirement = "";
  num uid = 0;


  bool isEditing = false;
  bool hasData = false;
  PlanData planData = PlanData();
  int curday = 0;
  List<ItiData> curData = [];


  void changeEditState(bool v){
    isEditing = v;
    notifyListeners();
  }

  void changeDataState(bool v){
    hasData = v;
    //if(!v) curData = [];
    notifyListeners();
  }

  void changeCurDay(int value){
    curday = value;
    curData = [];
    planData.itidata![curday].forEach((iti) => curData.add(iti));
    notifyListeners();
  }

  void setData({required DateTime start, required int num, required String require, required num userid}){
    start = start;
    numDays = num;
    requirement = require;
    uid = userid;
  }


  Future<void> createPlan() async {
    // isEditing = true;
    PlanData plan = PlanData.createWithDays(num: numDays, uid: uid);

    if(requirement == ""){

      print("create with num: ${numDays}, ${uid}");

    } else {

      print("create with llm : ${requirement}");

      List<List<ItiData>> list = await Api.instance.design_LLM(poinNum: numDays, requirement: requirement)??[[]];
      plan.itidata = list;
      //curData = plan.itidata![0];
      print("widget data: ${plan}");

      points = [];
      list.forEach((day) => day.forEach((point) => points.add(LatLng(point.y??114, point.x??30))));

      getRoute();

    }

    planData = plan;
    curData = [];
    planData.itidata![curday].forEach((iti) => curData.add(iti));
    changeDataState(true);

  }

  Future<void> readPlan(id) async {
    // isEditing = true;
    PlanData plan = await Api.instance.readPlanData(id: id);

    points = [];
    plan.itidata?.forEach((itis)=> itis.forEach((iti)=> points.add(LatLng(iti.y??30, iti.x??114))));
    getRoute();
    planData = plan;
    //curData = plan.itidata![0];
    curData = [];
    planData.itidata![curday].forEach((iti) => curData.add(iti));
    changeDataState(true);
  }


  Future<void> pushLocation({required int id}) async {
    // isEditing == true; hasData == true;

    ItiData itiData = await Api.instance.getSingleItiData(id: id);

    planData.itidata![curday].add(itiData);
    // curData.add(itiData);
    // curDataLength = curData.length;
    curData = [];
    planData.itidata![curday].forEach((iti) => curData.add(iti));
    print("PlanEditModel.pushLocation: pushed $itiData");
    notifyListeners();
    points = [];
    planData.itidata?.forEach((itis)=> itis.forEach((iti)=> points.add(LatLng(iti.y??30, iti.x??114))));
    getRoute();
  }

  void pushDay(){
    // isEditing == true; hasData == true;
    planData.itidata!.add([]);
    print("PlanEditModel.pushDay: now: ${planData.itidata}, curDay = ${planData.itidata!.length}");
    changeCurDay(planData.itidata!.length-1);
  }

  Future<void> uploadPlan() async {
    print("PanEditModel.uploadPlan: start");
    int id = await Api.instance.push_plan(planData: planData);
    planData.id = id;
  }


  List<LatLng> points = [];
  List<Polyline> route = [];




  Future<void> getRoute() async {
    print("plan_edit_model: getPoint");
    route = [];

    LatLng origin = points.first;

    final futures = <Future<void>>[];

    points.forEach((point) {
      if (origin != points.last) {
        futures.add(
          _fetchNavigationData(origin, point),
        );
        origin = point;
      }
    });

    await Future.wait(futures);

    if (this.hasListeners) {
      print("plan_edit_model.getpoint : notifyListener");
      notifyListeners();
    }

    print("got plan route points");
  }


  Future<void> _fetchNavigationData(LatLng origin, LatLng target) async {
    List<LatLng>? list = await Api.instance.navigationRequire(origin: origin, target: target);
    if (list != null) {
      route.add(planPolyline(list));
      print("PlanEditModel._fetchNavigationData: route add Polyline");
    } else {
      print("PlanEditModel._fetchNavigationData: Navigation response was null.");
    }
  }



}