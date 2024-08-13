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
      this.name, 
      this.point, 
      this.uid,});

  RecordListViewData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    point = json['point'] != null ? json['point'].cast<String>() : [];
    uid = json['uid'];
  }
  num? id;
  String? name;
  List<String>? point;
  num? uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['point'] = point;
    map['uid'] = uid;
    return map;
  }

  List<LatLng> getPointList(){
    List<LatLng> list = [];

    point?.forEach((p){
      var parts = p.split(',');
      list.add(LatLng(double.parse(parts[1]),double.parse(parts[0])));
    });

    return list;
  }
}