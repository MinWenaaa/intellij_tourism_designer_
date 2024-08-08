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
      this.pname,});

  SearchItemData.fromJson(dynamic json) {
    paddress = json['paddress'];
    pintroduceShort = json['pintroduce_short'];
    pname = json['pname'];
  }
  String? paddress;
  String? pintroduceShort;
  String? pname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paddress'] = paddress;
    map['pintroduce_short'] = pintroduceShort;
    map['pname'] = pname;
    return map;
  }

}