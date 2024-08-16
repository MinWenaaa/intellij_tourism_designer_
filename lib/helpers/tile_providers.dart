import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';

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
    tileProvider: CancellableNetworkTileProvider(),
  );
}

TileLayer WMS_ours({required String layerName}) {
  return TileLayer(
    wmsOptions: WMSTileLayerOptions(
      baseUrl: ConstantString.c657_wms,
      layers: [layerName],
    ),
    tileProvider: CancellableNetworkTileProvider(),
  );
}

