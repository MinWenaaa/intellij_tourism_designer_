import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/locations.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:latlong2/latlong.dart';
/*
* 制作存储各级图斑
*/
class MarkerElement{//制作图斑要素
  static const Marker nanwangshan = Marker(
    width: 80,
    height: 80,
    point: Location.nanwangshan,
    child: Icon(Icons.school_sharp, color: Color.fromARGB(255, 54, 168, 244),size: 60,),
  );
  static const Marker weilaicheng = Marker(
    width: 80,
    height: 80,
    point: Location.weilaicheng,
    child: Icon(Icons.school_sharp, color: Color.fromARGB(255, 244, 105, 54),size: 60,),
  );
  static const Marker home = Marker(
    width: 80,
    height: 80,
    point: Location.home,
    child: Icon(Icons.home, color: Color.fromARGB(255, 54, 244, 73),size: 60,),
  );
  static var weilaichengDetail = _getWeilaichengDetail();
  static Map<String, Marker> _getWeilaichengDetail(){
    var dict = Map<String, Marker>();
    Location.weilaichengDetail.forEach((key, value) {
      dict[key] = Marker(
        width: 40,
        height: 40,
        point: value,
        child: const Icon(Icons.double_arrow,color: Color.fromARGB(255, 27, 6, 77),size: 30,), 
      );
    });
    return dict;
  }




}

Marker deepSecondaryMarker(LatLng point){
  return Marker(
      width: 40, height: 40,
      point: point,
      child: Icon(Icons.location_on_sharp, color: AppColors.deepSecondary)
  );
}

Polyline planPolyline(List<LatLng> points){
  return Polyline(
    points: points,
    color: AppColors.secondary
  );
}

enum MarkerLevel{//划分显示图斑的等级与样式
    normal,
    none,
    detailed,
  }
class MarkerList{//制作图斑组
  static List<Marker> normalBookmark = [
    MarkerElement.nanwangshan,
    MarkerElement.weilaicheng,
    MarkerElement.home
  ];

  static List<Marker> noneBookmark = [];

  static List<Marker> weilaichengBookmark = [
    MarkerElement.nanwangshan,
    MarkerElement.weilaicheng,
    MarkerElement.home,
    ...MarkerElement.weilaichengDetail.values
  ];
}