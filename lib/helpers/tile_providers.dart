import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

/*
 * 用于封装瓦片地图服务
 */
enum MapServiceProvider {
  osm,
  google,
  baidu,
  mapbox,
  tianditu,
  gaode,
}

class BaseTileMap {
  //瓦片地图封装类
  final MapServiceProvider provider;
  final TileLayer map;
  final TextSourceAttribution info;

  BaseTileMap(MapServiceProvider mapProvider)
      : provider = mapProvider,
        map = _baseTileMap(mapProvider),
        info = _baseTileInfo(mapProvider);
}

//瓦片地图服务商实例化
TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'intellij_tourism_designer',
      // Use the recommended flutter_map_cancellable_tile_provider package to
      // support the cancellation of loading tiles.
      tileProvider: CancellableNetworkTileProvider(),
    );

TileLayer get googleTileLayer => TileLayer(
      urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
      userAgentPackageName: 'intellij_tourism_designer',
      tileProvider: CancellableNetworkTileProvider(),
    );

TileLayer get baiduTileLayer => TileLayer(
      urlTemplate:
          'https://api.map.baidu.com/customimage/tile?x={x}&y={y}&z={z}',
      userAgentPackageName: 'intellij_tourism_designer',
      tileProvider: CancellableNetworkTileProvider(),
    );

TileLayer get mapboxTileLayer => TileLayer(
      urlTemplate:
          'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw',
      userAgentPackageName: 'intellij_tourism_designer',
      tileProvider: CancellableNetworkTileProvider(),
    );

TileLayer get tiandituTileLayer => TileLayer(
      urlTemplate:
          'http://t0.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=7293b0825c52ef16081a15ce8dfd0b46',
      userAgentPackageName: 'intellij_tourism_designer',
      tileProvider: CancellableNetworkTileProvider(),
    );

TileLayer get gaodeTileLayer => TileLayer(
      urlTemplate:
          'https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
      userAgentPackageName: 'intellij_tourism_designer',
      tileProvider: CancellableNetworkTileProvider(),
    );

TextSourceAttribution _baseTileInfo(MapServiceProvider provider) {
  TextSourceAttribution info;
  switch (provider) {
    case MapServiceProvider.osm:
      info = TextSourceAttribution(
        '使用OpenStreetMap服务',
        onTap: () async => launchUrl(
          Uri.parse('https://openstreetmap.org/copyright'),
        ),
      );
      break;
    case MapServiceProvider.google:
      info = TextSourceAttribution(
        '使用Google服务',
        onTap: () async => launchUrl(
            Uri.parse('https://www.google.com/intl/zh-CN_us/help/terms_maps/')),
      );
      break;
    case MapServiceProvider.baidu:
      info = TextSourceAttribution(
        '使用百度服务',
        onTap: () async => launchUrl(Uri.parse('https://map.baidu.com/')),
      );
      break;
    case MapServiceProvider.mapbox:
      info = TextSourceAttribution(
        '使用Mapbox服务',
        onTap: () async => launchUrl(Uri.parse('https://www.mapbox.com/')),
      );
      break;
    case MapServiceProvider.tianditu:
      info = TextSourceAttribution(
        '使用天地图服务',
        onTap: () async => launchUrl(Uri.parse('https://www.tianditu.com/')),
      );
      break;
    case MapServiceProvider.gaode:
      info = TextSourceAttribution(
        '使用高德服务',
        onTap: () async => launchUrl(Uri.parse('https://www.amap.com/')),
      );
      break;
  }
  return info;
}

TileLayer _baseTileMap(MapServiceProvider provider) {
  //assert(provider != null, 'provider must not be null');
  TileLayer tileLayer;

  switch (provider) {
    case MapServiceProvider.osm:
      tileLayer = openStreetMapTileLayer;
      break;
    case MapServiceProvider.google:
      tileLayer = googleTileLayer;
      break;
    case MapServiceProvider.baidu:
      tileLayer = baiduTileLayer;
      break;
    case MapServiceProvider.mapbox:
      tileLayer = mapboxTileLayer;
      break;
    case MapServiceProvider.tianditu:
      tileLayer = tiandituTileLayer;
      break;
    case MapServiceProvider.gaode:
      tileLayer = gaodeTileLayer;
      break;
    default:
      throw AssertionError('Unsupported TileProvider $provider.');
  }
  return tileLayer;
}



TileLayer WMS_ours({required String layerName}) {
  return TileLayer(
    wmsOptions: WMSTileLayerOptions(
      baseUrl: "http://182.92.251.24:8080/geoserver/Esri_c657/wms?",
      layers: [layerName],
      otherParameters: {"request":"GetMap"},
    ),
    tileProvider: CancellableNetworkTileProvider(),
  );
}