import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

/*
 * 用于封装瓦片地图服务
 */

enum BaseLayerProvider{
  arcgis, gaode, baidu, arcgis2
}


class MapServiceProvider {
  MapServiceProvider._();

  static const List<String> baseServerURL = ['https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    'https://webst01.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}',
    'https://wayback.maptiles.arcgis.com/arcgis/rest/services/world_imagery/wmts/1.0.0/default028mm/mapserver/tile/45441/{z}/{y}/{x}'];

  static String c657_wms = "http://182.92.251.24:8080/geoserver/Esri_c657/wms?";
  static List<String> thematicLayerName = ['China', 'China', 'China', 'China'];

}

TileLayer baseTileLayer(int index){
  return TileLayer(
    urlTemplate: MapServiceProvider.baseServerURL[index],
    userAgentPackageName: 'intellij_tourism_designer',
    tileProvider: CancellableNetworkTileProvider(),
  );
}

TileLayer WMS_ours({required String layerName}) {
  return TileLayer(
    wmsOptions: WMSTileLayerOptions(
      baseUrl: MapServiceProvider.c657_wms,
      layers: [layerName],
    ),
    tileProvider: CancellableNetworkTileProvider(),
  );
}

