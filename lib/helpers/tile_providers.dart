import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'dart:convert';
import 'dart:io';

/*
 * 用于封装瓦片地图服务
 */

enum BaseLayerProvider{
  arcgis, gaode, baidu, arcgis2
}


TileLayer baseTileLayer(int index){
  return TileLayer(
    urlTemplate: ConstantString.baseServerURL[index],
    userAgentPackageName: 'intellij_tourism_designer',
    tileProvider: NetworkTileProvider(),
  );
}

TileLayer WMS_ours({required String layerName}) {
  return TileLayer(
    wmsOptions: WMSTileLayerOptions(
      baseUrl: ConstantString.c657_wms,
      layers: [layerName],
    ),
    tileProvider: NetworkTileProvider(),
  );
}



Future<Map<String, dynamic>> loadJsonFromAsset() async {
  final jsonString = await rootBundle.loadString('assets/wuhan.json');
  return jsonDecode(jsonString);
}
