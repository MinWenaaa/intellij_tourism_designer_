import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/helpers/Iti_data.dart';
import 'package:latlong2/latlong.dart';
import '../http/Api.dart';

class PlanEditModel with ChangeNotifier{

  DateTime start = DateTime.now();
  int numDays = 0;
  String requirement = "";
  num uid = 0;
  late Future<PlanData> planData;
  int state = 0;

  void changeState(int s){
    state = s;
    notifyListeners();
  }

  List<LatLng> points = [];
  List<List<LatLng>> route = [];

  Future<PlanData> createPlan() async {
    PlanData plan = PlanData.createWithDays(num: numDays, uid: uid);
    if(requirement == ""){
      print("create with num: ${numDays}, ${uid}");
      return plan;
    }else{
      print("create with llm : ${requirement}");
      List<List<ItiData>> list = await Api.instance.design_LLM(poinNum: numDays*3, requirement: requirement)??[[]];
      plan.itidata = list;
      print("widget data: ${plan}");
      points = [];
      list.forEach((day) => day.forEach((point) => points.add(LatLng(point.y??114, point.x??30))));
      getPoint().then((value){notifyListeners();
        print("plan_edit_model.fetchPlan: notifylistener");
      });
      return plan;
    }
  }

  Future<PlanData> readPlan(id) async {
    PlanData plan = await Api.instance.readPlanData(id: id);
    points = [];
    plan.itidata?.forEach((itis)=> itis.forEach((iti)=> points.add(LatLng(iti.y??30, iti.x??114))));
    getPoint();
    return plan;
  }

  void setData({required DateTime start, required int num, required String require, required num uid}){
    start = start;
    numDays = num;
    requirement = require;
    uid = uid;
    state = 1;
  }

  void init(){
    planData = createPlan();
  }

  void loadPlan(id){
    state = 1;
    planData = readPlan(id);
  }


  Future<void> getPoint() async {
    print("plan_edit_model: getPoint");
    route = [];

    LatLng origin = points.first;

    final futures = <Future<void>>[];

    points.forEach((point) {
      if (point != points.last) {
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
      route.add(list);
      print("PlanEditModel._fetchNavigationData: Get answer of navigation: ${list.last}");
    } else {
      print("PlanEditModel._fetchNavigationData: Navigation response was null.");
    }
  }

}