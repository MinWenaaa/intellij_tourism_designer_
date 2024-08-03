
class PoiDetail {
  PoiDetail({
      this.paddress, 
      this.pclass, 
      this.pgrade, 
      this.pid, 
      this.pintroduceLong, 
      this.pintroduceShort, 
      this.plevel, 
      this.plocation, 
      this.pname, 
      this.popenTime, 
      this.pphonenumber, 
      this.pphoto, 
      this.pprice, 
      this.prank, 
      this.precommendedDuration, 
      this.ptype,});

  PoiDetail.fromJson(dynamic json) {
    paddress = json['paddress'];
    pclass = json['pclass'];
    pgrade = json['pgrade'];
    pid = json['pid'];
    pintroduceLong = json['pintroduce_long'];
    pintroduceShort = json['pintroduce_short'];
    plevel = json['plevel'];
    plocation = json['plocation'] != null ? Plocation.fromJson(json['plocation']) : null;
    pname = json['pname'];
    popenTime = json['popen_time'];
    pphonenumber = json['pphonenumber'];
    pphoto = json['pphoto'] != null ? json['pphoto'].cast<String>() : [];
    pprice = json['pprice'];
    prank = json['prank'];
    precommendedDuration = json['precommended_duration'];
    ptype = json['ptype'];
  }
  String? paddress;
  String? pclass;
  String? pgrade;
  num? pid;
  String? pintroduceLong;
  String? pintroduceShort;
  String? plevel;
  Plocation? plocation;
  String? pname;
  String? popenTime;
  String? pphonenumber;
  List<String>? pphoto;
  String? pprice;
  String? prank;
  String? precommendedDuration;
  String? ptype;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paddress'] = paddress;
    map['pclass'] = pclass;
    map['pgrade'] = pgrade;
    map['pid'] = pid;
    map['pintroduce_long'] = pintroduceLong;
    map['pintroduce_short'] = pintroduceShort;
    map['plevel'] = plevel;
    if (plocation != null) {
      map['plocation'] = plocation?.toJson();
    }
    map['pname'] = pname;
    map['popen_time'] = popenTime;
    map['pphonenumber'] = pphonenumber;
    map['pphoto'] = pphoto;
    map['pprice'] = pprice;
    map['prank'] = prank;
    map['precommended_duration'] = precommendedDuration;
    map['ptype'] = ptype;
    return map;
  }

}


class Plocation {
  Plocation({
      this.x, 
      this.y,});

  Plocation.fromJson(dynamic json) {
    x = json['x'];
    y = json['y'];
  }
  num? x;
  num? y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = x;
    map['y'] = y;
    return map;
  }

}