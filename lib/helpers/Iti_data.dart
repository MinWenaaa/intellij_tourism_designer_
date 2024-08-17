/// paddress : "湖北省武汉市武昌区武珞路特1号"
/// pid : 69
/// pintroduce_short : "辛亥革命的纪念地，集历史纪念、文化展示与市民休闲于一体"
/// pname : "首义广场"
/// pphoto : "https://dimg04.c-ctrip.com/images/fd/tg/g3/M09/37/D9/CggYGlY5ZE2ARiPpAA4woo3fTrU128_R_1600_10000.jpg"
/// x : 114.305227
/// y : 30.53704

class PlanData {
  PlanData({
    this.uid,
    this.name,
    this.id,
    this.editTime,
    this.pic,
    this.itidata,
});

  List<List<ItiData>>? itidata = [];
  String? editTime = "";
  String? pic = "https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp";
  String? name = "新建行程";
  num? id = 0;
  num? uid = 0;


  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itidata'] = itidata?.map((list) => list.map((item) => item.toJson()).toList()).toList();
    data['editTime'] = editTime;
    data['pic'] = pic;
    data['name'] = name;
    data['id'] = id;
    data['uid'] = uid;
    return data;
  }

  PlanData.fromJson(Map<String, dynamic> json) {
    itidata = json['itidata']?.map(
          (listJson) => listJson.map((itemJson) => ItiData.fromJson(itemJson)).toList(),
    ).toList()??[];
    editTime = json['editTime'] as String;
    pic = json['pic'] as String;
    name = json['name'] as String;
    id = json['id'] as num;
    uid = json['uid'] as num;
  }

  factory PlanData.createWithDays({required int num, required num uid}){
    final PlanData planData  = PlanData(itidata: []);
    for(int i =0; i<num; i++){
      planData.itidata?.add([]);
      print("itidata add [], now ${planData.itidata}");
    }
    planData.uid = uid;
    return planData;
  }


}


class ItiListData{

  List<List<ItiData>>? itiList;

  ItiListData.fromJson(dynamic json){
    itiList = [];
    if(json is List){
      for(var element in json){
        List<ItiData> temp = [];
        //print(element);
        for(var iti in element){
          temp.add(ItiData.fromJson(iti));
        }
        itiList?.add(temp);
      }
    }
  }

}




class ItiData {
  ItiData({
      this.paddress, 
      this.pid, 
      this.pintroduceShort, 
      this.pname, 
      this.pphoto, 
      this.x, 
      this.y,
      this.time});

  ItiData.fromJson(dynamic json) {
    paddress = json['paddress'];
    pid = json['pid'];
    pintroduceShort = json['pintroduce_short'];
    pname = json['pname'];
    pphoto = json['pphoto'];
    x = json['x'];
    y = json['y'];
    time = json['time'];
  }
  String? paddress;
  num? pid;
  String? pintroduceShort;
  String? pname;
  String? pphoto;
  double? x;
  double? y;
  String? time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paddress'] = paddress;
    map['pid'] = pid;
    map['pintroduce_short'] = pintroduceShort;
    map['pname'] = pname;
    map['pphoto'] = pphoto;
    map['x'] = x;
    map['y'] = y;
    map['time'] = time;
    return map;
  }

}