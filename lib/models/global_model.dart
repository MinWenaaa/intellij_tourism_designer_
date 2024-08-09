import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class GlobalModel with ChangeNotifier{

  int baseProvider = 0;
  LatLng center = LatLng(30.6,114.3);
  List<bool> poiMarker = [false, false, false, false];
  List<bool> thematicMap = [false];

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