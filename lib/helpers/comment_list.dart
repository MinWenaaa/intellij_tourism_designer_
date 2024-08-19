/* poi评论数据*/

class CommentListData{

  List<CommentData>? listData;

  CommentListData.fromJson(dynamic json){
    listData = [];
    if(json is List){
      for(var element in json){
        listData?.add(CommentData.fromJson(element));
      }
    }
  }

}
class CommentData {
  CommentData({
    this.ccontent,
    this.cgrade,
    this.cid,
    this.cphoto,
    this.cpid,
    this.cpname,
    this.ctime,
    this.cuid,});

  CommentData.fromJson(dynamic json) {
    ccontent = json['ccontent'];
    cgrade = json['cgrade'];
    cid = json['cid'];
    cphoto = json['cphoto'] != null ? json['cphoto'].cast<String>() : [];
    cpid = json['cpid'];
    cpname = json['cpname'];
    ctime = json['ctime'];
    cuid = json['cuid'];
  }
  String? ccontent;
  num? cgrade;
  int? cid;
  List<String>? cphoto;
  int? cpid;
  String? cpname;
  String? ctime;
  int? cuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ccontent'] = ccontent;
    map['cgrade'] = cgrade;
    map['cid'] = cid;
    map['cphoto'] = cphoto;
    map['cpid'] = cpid;
    map['cpname'] = cpname;
    map['ctime'] = ctime;
    map['cuid'] = cuid;
    return map;
  }

}