/// uid : 200
/// unickname : "最强前端爆破手"
/// upic : "https://gd-hbimg.huaban.com/4a98129153440fcf80daf54263077a0723848e411a909-9PHrUU_fw1200webp"

class User {
  User({
      this.uid, 
      this.unickname, 
      this.upic,});

  User.fromJson(dynamic json) {
    uid = json['uid'];
    unickname = json['unickname'];
    upic = json['upic'];
  }
  num? uid;
  String? unickname;
  String? upic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['unickname'] = unickname;
    map['upic'] = upic;
    return map;
  }

}