import 'package:intl/intl.dart';

const double MINZOOM = 5.0;
const double MAXZOOM = 18.0;

class ConstantString{
  ConstantString._();

  static const String attraction = "旅游景点";
  static const String dining = "餐饮美食";
  static const String hotel = "酒店住宿";
  static const String camera = "机位信息";

  static const List<String> poi = [
    attraction, dining, hotel, camera
  ];

  static const List<String> poi_layer = [
    "wuhan_attraction_poi",
    "wuhan_restaurant_poi",
    "wuhan_hotel_poi",
    "wuhan_photo_poi",
  ];

  static List<String> sunsetLayer = ['241120', '241020', '240920', '240820', '240720', '240620', '240720', '240820', '240920', '241020', '241120', '241221'];
  static List<String> heatMap = ['Attraction_Heatmap', 'Restaurant_Heatmap', 'Hotel_Heatmap', 'Photo_Heatmap'];
  static List<String> featureLayer = ['History_Heatmap', 'Nature_Heatmap', 'Scenery_Heatmap', 'Recreation_Heatmap', 'Religion_Heatmap', 'Scenery_Heatmap'];


  static const List<String> poi_icon_url = [
    "https://gd-hbimg.huaban.com/33a7b811d0e36b0605deaeb7d93b583d18efb05d1a7d-oWSGNy_fw1200webp",
    "https://gd-hbimg.huaban.com/8a3b181a9aeea66947a1e1f1afdced36e60848f41960-ipRuLh_fw1200webp",
    "https://gd-hbimg.huaban.com/8b7d86785d2e648c7428e89e71837a036585c31b1a7c-Z2086e_fw1200webp",
    "https://gd-hbimg.huaban.com/f5d37faa10c52475039ecef5ecfe000c29f5a6241a87-CTZred_fw1200webp",
  ];

  static const List<String> weather_icon = [
    "https://gd-hbimg.huaban.com/e9e0bba4f572463c0cebad18c7dddf0c1abbe4c4167b0-KIgEe9_fw1200webp",
    "https://gd-hbimg.huaban.com/661d1503fa127157551a70e36a126269139a800d9b815-x29MMk_fw1200webp",
    "https://gd-hbimg.huaban.com/f23a9683e66012dd6277c48338d022a65f31e584102f9-tJZhhg_fw1200webp",
    "https://gd-hbimg.huaban.com/ebd4d2544bebbe56e231fcb5e4953394942876e620d4c-bf5AtZ_fw1200webp"
  ];

  static const List<String> weekDay = [
    "Mon", "Tue", "Wen", "Tur", "Fri", "Sat", "Sun"
  ];

  static const List<String> month = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> baseServerURL = ['https://webrd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    'https://webst01.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}',
    'https://wayback.maptiles.arcgis.com/arcgis/rest/services/world_imagery/wmts/1.0.0/default028mm/mapserver/tile/45441/{z}/{y}/{x}'];

  static String c657_wms = "http://182.92.251.24:8080/geoserver/Esri_c657/wms?";

}

const Duration defaultTime = const Duration(seconds: 10);

DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

