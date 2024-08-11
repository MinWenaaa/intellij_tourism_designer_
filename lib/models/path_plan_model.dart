import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';

class PathPlanModel with ChangeNotifier{

  List<LatLng> points = [];
  List<LatLng> Route = [];
  List<Marker> markers = [];


  Future<void> addPoint(LatLng point) async {
    print("triger addPoint: ${point}");
    if(points.isNotEmpty){
      Api.instance.navigationRequire(
        origin: points.last,
        target: point,
      ).then((value){
        if (value != null) {
          Route.addAll(value as Iterable<LatLng>);
          print("Get answer of navigation: ${value.last}");
        } else {
          print("Navigation response was null.");
        }
      });
      notifyListeners();
    }
    points.add(point);
    markers.add(deepSecondaryMarker(point));
    print("now: $points");

    if (this.hasListeners) {
      notifyListeners();
    }
  }

}