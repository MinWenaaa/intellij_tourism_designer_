
class NavigationData {
  NavigationData({
      this.status, 
      this.info, 
      this.infocode, 
      this.count, 
      this.route,});

  NavigationData.fromJson(dynamic json) {
    status = json['status'];
    info = json['info'];
    infocode = json['infocode'];
    count = json['count'];
    route = json['route'] != null ? Route.fromJson(json['route']) : null;
  }
  String? status;
  String? info;
  String? infocode;
  String? count;
  Route? route;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['info'] = info;
    map['infocode'] = infocode;
    map['count'] = count;
    if (route != null) {
      map['route'] = route?.toJson();
    }
    return map;
  }

}


class Route {
  Route({
      this.origin, 
      this.destination, 
      this.paths,});

  Route.fromJson(dynamic json) {
    origin = json['origin'];
    destination = json['destination'];
    if (json['paths'] != null) {
      paths = [];
      json['paths'].forEach((v) {
        paths?.add(Paths.fromJson(v));
      });
    }
  }
  String? origin;
  String? destination;
  List<Paths>? paths;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['origin'] = origin;
    map['destination'] = destination;
    if (paths != null) {
      map['paths'] = paths?.map((v) => v.toJson()).toList();
    }
    return map;
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

}


class Steps {
  Steps({
      this.instruction, 
      this.orientation, 
      this.road, 
      this.distance, 
      this.duration, 
      this.polyline, 
      this.action, 
      this.assistantAction, 
      this.walkType,});

  Steps.fromJson(dynamic json) {
    instruction = json['instruction'];
    orientation = json['orientation'];
    road = json['road'];
    distance = json['distance'];
    duration = json['duration'];
    polyline = json['polyline'];
    action = json['action'];
    assistantAction = json['assistantAction'];
    walkType = json['walk_type'];
  }
  String? instruction;
  String? orientation;
  List<dynamic>? road;
  String? distance;
  String? duration;
  String? polyline;
  String? action;
  List<dynamic>? assistantAction;
  String? walkType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['instruction'] = instruction;
    map['orientation'] = orientation;
    if (road != null) {
      map['road'] = road?.map((v) => v.toJson()).toList();
    }
    map['distance'] = distance;
    map['duration'] = duration;
    map['polyline'] = polyline;
    map['action'] = action;
    if (assistantAction != null) {
      map['assistant_action'] = assistantAction?.map((v) => v.toJson()).toList();
    }
    map['walk_type'] = walkType;
    return map;
  }

}