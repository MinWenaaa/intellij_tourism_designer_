import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intellij_tourism_designer/helpers/User.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';

class GlobalModel with ChangeNotifier{

  User user = User(
    uid: 0,
    unickname: "未登录",
    upic: "https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp"
  );

  int baseProvider = 0;
  LatLng center = LatLng(30.6,114.3);
  List<bool> poiMarker = [false, false, false, false];
  List<bool> thematicMap = [false];



  Future<bool> Login({required String name, required String password}) async {
    final result = await Api.instance.UserLogin(name: name, password: password);
    if (result == null) {
      return false;
    } else {
      user = result;
      return true;
    }
  }

  void changeBaseLayer(int provider){
    baseProvider = provider;
    notifyListeners();
  }

  void changePoiMarker(int index, bool flag){
    poiMarker[index] = flag;
    notifyListeners();
  }

  void changeCenter(LatLng newCenter){
    center = newCenter;
    notifyListeners();
  }


}