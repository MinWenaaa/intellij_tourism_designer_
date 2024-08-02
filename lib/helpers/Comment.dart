class Comment {
  Comment({
      this.cuid, 
      this.ctime, 
      this.cgrade, 
      this.ccontent, 
      this.cphoto, 
      this.caname,});

  Comment.fromJson(dynamic json) {
    cuid = json['Cuid'];
    ctime = json['Ctime'];
    cgrade = json['Cgrade'];
    ccontent = json['Ccontent'];
    cphoto = json['Cphoto'] != null ? json['Cphoto'].cast<String>() : [];
    caname = json['Caname'];
  }
  num? cuid;
  String? ctime;
  num? cgrade;
  String? ccontent;
  List<String>? cphoto;
  String? caname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Cuid'] = cuid;
    map['Ctime'] = ctime;
    map['Cgrade'] = cgrade;
    map['Ccontent'] = ccontent;
    map['Cphoto'] = cphoto;
    map['Caname'] = caname;
    return map;
  }

}