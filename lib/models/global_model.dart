import 'package:flutter/cupertino.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';

class GlobalModel with ChangeNotifier{

  int baseProvider = 0;
  LatLng center = LatLng(30.6,114.3);
  List<bool> poiMarker = [false, false, false, false];
  List<bool> thematicMap = [false];

  bool recordCenter = false;
  List<LatLng> points = [];
  List<LatLng> Route = [];

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

  void RecordCenterFlagChange(){
    print("flag changed: ${recordCenter}");
    recordCenter = !recordCenter;
    notifyListeners();
  }


  Future<void> addPoint(LatLng point) async {
    print("triger addPoint: ${point}");
    if(points.isNotEmpty){
      await Api.instance.navigationRequire(origin: points.last, target: point)
          .then((value) {
        Route.addAll(value as Iterable<LatLng>);
        print("get answer of navigation: ${value?.last}");
      });
      notifyListeners();
    }
    points.add(point);
    print("now: $points");

    notifyListeners();
  }

}