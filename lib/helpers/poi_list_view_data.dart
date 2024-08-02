/*
移动端首页 与 桌面端地图模块 的 POI列表视图数据
 */

class PoiListData{

  List<PoiListViewData>? poiList;

  PoiListData.fromJson(dynamic json){
    poiList = [];
    if(json is List){
      for(var element in json){
        poiList?.add(PoiListViewData.fromJson(element));
      }
    }
  }

}



class PoiListViewData {
  PoiListViewData({
      this.paddress, 
      this.pclass, 
      this.pgrade, 
      this.pid, 
      this.pintroduceShort, 
      this.plevel, 
      this.pname, 
      this.popenTime, 
      this.pphonenumber, 
      this.pphoto, 
      this.pprice, 
      this.prank, 
      this.precommendedDuration,});

  PoiListViewData.fromJson(dynamic json) {
    paddress = json['paddress'];
    pclass = json['pclass'];
    pgrade = json['pgrade'];
    pid = json['pid'];
    pintroduceShort = json['pintroduce_short'];
    plevel = json['plevel'];
    pname = json['pname'];
    popenTime = json['popen_time'];
    pphonenumber = json['pphonenumber'];
    pphoto = json['pphoto'];
    pprice = json['pprice'];
    prank = json['prank'];
    precommendedDuration = json['precommended_duration'];
  }
  String? paddress;
  String? pclass;
  String? pgrade;
  num? pid;
  String? pintroduceShort;
  String? plevel;
  String? pname;
  String? popenTime;
  String? pphonenumber;
  String? pphoto;
  String? pprice;
  String? prank;
  String? precommendedDuration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paddress'] = paddress;
    map['pclass'] = pclass;
    map['pgrade'] = pgrade;
    map['pid'] = pid;
    map['pintroduce_short'] = pintroduceShort;
    map['plevel'] = plevel;
    map['pname'] = pname;
    map['popen_time'] = popenTime;
    map['pphonenumber'] = pphonenumber;
    map['pphoto'] = pphoto;
    map['pprice'] = pprice;
    map['prank'] = prank;
    map['precommended_duration'] = precommendedDuration;
    return map;
  }

}