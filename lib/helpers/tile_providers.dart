import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

/*
 * 用于封装瓦片地图服务
 */
class MapServiceProvider {
  MapServiceProvider._();

  static String openStreetMap = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static String google = 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
  static String baidu = 'https://api.map.baidu.com/customimage/tile?x={x}&y={y}&z={z}';
  static String mapBox = 'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw';
  static String tianditu = 'http://t0.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=7293b0825c52ef16081a15ce8dfd0b46';
  static String gaode = 'https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}';
  static String c657_wms = "http://182.92.251.24:8080/geoserver/Esri_c657/wms?";

  static List<String> thematicLayerName = ['China', 'China', 'China', 'China'];

}

TileLayer baseTileLayer(String provider){
  return TileLayer(
    urlTemplate: provider,
    userAgentPackageName: 'intellij_tourism_designer',
    tileProvider: CancellableNetworkTileProvider(),
  );
}

TileLayer WMS_ours({required String layerName}) {
  return TileLayer(
    wmsOptions: WMSTileLayerOptions(
      baseUrl: MapServiceProvider.c657_wms,
      layers: [layerName],
      otherParameters: {"request":"GetMap"},
    ),
    tileProvider: CancellableNetworkTileProvider(),
  );
}