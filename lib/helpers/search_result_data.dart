class SearchListData{

  List<SearchItemData?>? itemList;

  SearchListData.fromJson(dynamic json){
    itemList = [];
    if(json is List){
      for(var element in json){
        itemList?.add(SearchItemData.fromJson(element));
      }
    }
  }

}

class SearchItemData {
  SearchItemData({
      this.paddress, 
      this.pintroduceShort, 
      this.pname,
    this.x,
    this.y
  });

  SearchItemData.fromJson(dynamic json) {
    paddress = json['paddress'];
    pintroduceShort = json['pintroduce_short'];
    pname = json['pname'];
    x = json['x'];
    y = json['y'];
  }
  String? paddress;
  String? pintroduceShort;
  String? pname;
  double? x;
  double? y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paddress'] = paddress;
    map['pintroduce_short'] = pintroduceShort;
    map['pname'] = pname;
    map['x'] = x;
    map['y'] = y;
    return map;
  }

}