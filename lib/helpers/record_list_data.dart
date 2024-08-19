import 'package:latlong2/latlong.dart';

/// id : 7
/// name : "2024-08-13 13:09:13"
/// point : ["114.3,30.6","114.4,30.5","114.39882094896825,30.498984108183425","114.39882094896825,30.498984108183425","114.38956114052911,30.497036557366556","114.38749184786398,30.49523853099728","114.38697747756471,30.499730798825023"]
/// uid : 200

class RecordListData{

  List<RecordListViewData>? recordList;

  RecordListData.fromJson(dynamic json){
    recordList = [];
    if(json is List){
      for(var element in json){
        recordList?.add(RecordListViewData.fromJson(element));
      }
    }
  }

}


class RecordListViewData {
  RecordListViewData({
      this.id, 
      this.name,});

  RecordListViewData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}


/// events : [{"id":4,"point":"114.40343904172155, 30.50276419339164","rid":28,"text":"very good"},{"id":5,"point":"114.40343904172155, 30.50276419339164","rid":28,"text":"very good\n"}]
/// points : ["114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.4,30.5","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164","114.40343904172155,30.50276419339164"]

class RecordDetail {
  RecordDetail({
    this.events,
    this.points,});

  RecordDetail.fromJson(dynamic json) {
    if (json['events'] != null) {
      events = [];
      json['events'].forEach((v) {
        events?.add(Events.fromJson(v));
      });
    }
    List<String> temp = json['points'] != null ? json['points'].cast<String>() : [];
    points = List.generate(temp.length, (index) {
      var parts = temp[index].split(',');
      return LatLng(double.parse(parts[1]), double.parse(parts[0]));
    });
  }
  List<Events>? events;
  List<LatLng>? points;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (events != null) {
      map['events'] = events?.map((v) => v.toJson()).toList();
    }
    map['points'] = List.generate(points?.length??0, (index)=>"${points![index].longitude},${points![index].latitude}");
    return map;
  }

}

/// id : 4
/// point : "114.40343904172155, 30.50276419339164"
/// rid : 28
/// text : "very good"

class Events {
  Events({
    this.id,
    this.point,
    this.rid,
    this.text,});

  Events.fromJson(dynamic json) {
    id = json['id'];
    var pair = json['point'].split(',');
    rid = json['rid'];
    text = json['text'];
    point = LatLng(double.parse(pair[1]), double.parse(pair[0]));
  }
  num? id;
  LatLng? point;
  num? rid;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['point'] = "${point?.latitude??30},${point?.longitude??114}";
    map['rid'] = rid;
    map['text'] = text;
    return map;
  }

}