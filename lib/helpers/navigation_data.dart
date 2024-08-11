import 'package:latlong2/latlong.dart';

class NavigationData {
  NavigationData({
      this.count, 
      this.info, 
      this.infocode, 
      this.route, 
      this.status,});

  NavigationData.fromJson(dynamic json) {
    count = json['count'];
    info = json['info'];
    infocode = json['infocode'];
    route = json['route'] != null ? Route.fromJson(json['route']) : null;
    status = json['status'];
  }
  String? count;
  String? info;
  String? infocode;
  Route? route;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    map['info'] = info;
    map['infocode'] = infocode;
    if (route != null) {
      map['route'] = route?.toJson();
    }
    map['status'] = status;
    return map;
  }

  List<LatLng> getPointList() {
    return route?.getPointList()??[];
  }

}


class Route {
  Route({
      this.destination, 
      this.origin, 
      this.paths,});

  Route.fromJson(dynamic json) {
    destination = json['destination'];
    origin = json['origin'];
    if (json['paths'] != null) {
      paths = [];
      json['paths'].forEach((v) {
        paths?.add(Paths.fromJson(v));
      });
    }
  }
  String? destination;
  String? origin;
  List<Paths>? paths;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['destination'] = destination;
    map['origin'] = origin;
    if (paths != null) {
      map['paths'] = paths?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  List<LatLng> getPointList() {

    List<LatLng> list = [];
    paths?.forEach((step) => list.addAll(step.getPointList()));
    return list;

  }

}


class Paths {
  Paths({
      this.distance, 
      this.duration, 
      this.steps,});

  Paths.fromJson(dynamic json) {
    distance = json['distance'];
    duration = json['duration'];
    if (json['steps'] != null) {
      steps = [];
      json['steps'].forEach((v) {
        steps?.add(Steps.fromJson(v));
      });
    }
  }
  String? distance;
  String? duration;
  List<Steps>? steps;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['distance'] = distance;
    map['duration'] = duration;
    if (steps != null) {
      map['steps'] = steps?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  List<LatLng> getPointList() {

    List<LatLng> list = [];
    steps?.forEach((step) => list.addAll(step.getPointList()));
    return list;

  }

}


class Steps {
  Steps({
      this.action, 
      this.assistantAction, 
      this.distance, 
      this.duration, 
      this.instruction, 
      this.orientation, 
      this.polyline, 
      this.road, 
      this.walkType,});

  Steps.fromJson(dynamic json) {
    action = json['action'];
    assistantAction = json['assistant_action'];
    distance = json['distance'];
    duration = json['duration'];
    instruction = json['instruction'];
    orientation = json['orientation'];
    polyline = json['polyline'];
    road = json['road'];
    walkType = json['walk_type'];
  }
  dynamic? action;
  dynamic? assistantAction;
  String? distance;
  String? duration;
  String? instruction;
  dynamic? orientation;
  String? polyline;
  dynamic? road;
  String? walkType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['action'] = action;
    if (assistantAction != null) {
      map['assistant_action'] = assistantAction?.map((v) => v.toJson()).toList();
    }
    map['distance'] = distance;
    map['duration'] = duration;
    map['instruction'] = instruction;
    map['orientation'] = orientation;
    map['polyline'] = polyline;
    map['road'] = road;
    map['walk_type'] = walkType;
    return map;
  }

  List<LatLng> getPointList(){
    List<LatLng> list = [];

    if(polyline != null) {
      polyline!.split(';').forEach((nums){
        var parts = nums.split(',');
        list.add(LatLng(double.parse(parts[1]),double.parse(parts[0])));
      });
    }

    return list;
  }

}