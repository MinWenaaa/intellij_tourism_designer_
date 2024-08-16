import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/helpers/Iti_data.dart';
import '../http/Api.dart';

class PlanEditModel with ChangeNotifier{
  DateTime start = DateTime.now();
  int numDays = 0;
  String requirement = "";
  num uid = 0;
  late Future<PlanData> planData;

  Future<PlanData> fetchPlan() async {
    PlanData plan = PlanData.createWithDays(num: numDays, uid: uid);
    if(requirement == ""){
      print("create with num");
      return plan;
    }else{
      print("create with llm : ${requirement}");
      List<List<ItiData>> list = await Api.instance.design_LLM(poinNum: numDays*3, requirement: requirement)??[[]];
      plan.itidata = list;
      print("widget data: ${plan}");
      return plan;
    }
  }



  void setData({required DateTime start, required int num, required String require, required num uid}){

  }

  void init(){
    planData = fetchPlan();
    notifyListeners();
  }

}