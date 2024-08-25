import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';

class PathPlanModel with ChangeNotifier{

  List<LatLng> points = [];
  List<Polyline> Route = [];
  List<Marker> markers = [];

  // void clear(){
  //   points = [];
  //   Route = [];
  //   markers = [];
  //   notifyListeners();
  // }

  Future<void> addPoint(LatLng point) async {
    points = [...points, point];
    markers.add(deepSecondaryMarker(point));

    getRoute();
    if (this.hasListeners) {
      notifyListeners();
    }
  }

  void Reorder(int oldIndex, int newIndex){
    LatLng temp = points[oldIndex];
    points[oldIndex] = points[newIndex];
    points[newIndex] = temp;

    getRoute();

  }

  Future<void> getRoute() async {
    print("Path_plan_model: getPoint");
    Route = [];

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
      Route.add(planPolyline(list));
      print("PathPlanModel._fetchNavigationData: Get answer of navigation: ${list.last}");
    } else {
      print("PathPlanModel._fetchNavigationData: Navigation response was null.");
    }
  }


}