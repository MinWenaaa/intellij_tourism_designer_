import 'package:flutter/cupertino.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import '../http/Api.dart';

class HomeViewModel with ChangeNotifier{
  int loadCount=1;
  List<PoiListViewData>? listData;

  Future<List<PoiListViewData>?> loadListData(String type) async{
    listData = await Api.instance.getPOIList(type, loadCount);
    notifyListeners();
  }
}