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

  List<LatLng> points = [];
  List<List<LatLng>> route = [];

  Future<PlanData> fetchPlan() async {
    PlanData plan = PlanData.createWithDays(num: numDays, uid: uid);
    if(requirement == ""){
      print("create with num: ${numDays}, ${uid}");
      return plan;
    }else{
      print("create with llm : ${requirement}");
      List<List<ItiData>> list = await Api.instance.design_LLM(poinNum: numDays*3, requirement: requirement)??[[]];
      plan.itidata = list;
      print("widget data: ${plan}");
      list.forEach((day) => day.forEach((point) => points.add(LatLng(point.y??114, point.x??30))));
      getPoint().then((value){notifyListeners();
        print("plan_edit_model.fetchPlan: notifylistener");
      });
      return plan;
    }
  }


  void setData({required DateTime start, required int num, required String require, required num uid}){
    start = start;
    numDays = num;
    requirement = require;
    uid = uid;
  }

  void init(){
    planData = fetchPlan();
  }

  // Future<void> getPoint() async {
  //   print("plan_edit_model: getPoint");
  //   route = [];
  //   LatLng origin = points.first;
  //   points.forEach((point) async {
  //     if(point!=points.last){
  //       List<LatLng>? list = await Api.instance.navigationRequire(origin: origin, target: point,);
  //       if (list != null) {
  //           route.add(list );
  //           print("Get answer of navigation: ${list.last}");
  //       } else {
  //           print("Navigation response was null.");
  //         }
  //       }
  //
  //       origin = point;
  //     notifyListeners();
  //     print("plan_edit_model.forEach : notifyListener");
  //   });
  //
  //   print("got plan route points");
  //   if (this.hasListeners) {
  //     print("plan_edit_model.getpoint : notifynisener");
  //     notifyListeners();
  //   }
  //
  // }

  Future<void> getPoint() async {
    print("plan_edit_model: getPoint");
    route = [];

    // 获取第一个点作为起点
    LatLng origin = points.first;

    // 创建一个Future列表，用于等待所有导航数据获取完成
    final futures = <Future<void>>[];

    // 遍历每个点，创建Future任务并添加到futures列表中
    points.forEach((point) {
      if (point != points.last) {
        futures.add(
          _fetchNavigationData(origin, point),
        );
        origin = point;
      }
    });

    // 等待所有Future任务完成
    await Future.wait(futures);

    // 所有导航数据获取完成后调用 notifyListeners()
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
      print("Get answer of navigation: ${list.last}");
    } else {
      print("Navigation response was null.");
    }
  }

}