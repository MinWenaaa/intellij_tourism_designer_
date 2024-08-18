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
    "https://gd-hbimg.huaban.com/ca86b82532f91c2e68a8379a7938bd80117561e31f33-u4F76m_fw1200webp",
    "https://gd-hbimg.huaban.com/4a9eef2cf5a8b205bd2bea27cd84dcfc94d5462e20ae-E1Hlcp_fw1200webp",
    "https://gd-hbimg.huaban.com/8b01201be4b9085ab7e57dd60834ab7186c75ab01da4-J3cQpJ_fw1200webp",
    "https://gd-hbimg.huaban.com/dc13a2c8b6fbf2a0c56d757eb6f681516b4fbe2520f5-5apI0K_fw1200webp"
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

  static const Map<String, List<String>> poiHeadIcon ={
    attraction: [
      "https://gd-hbimg.huaban.com/e2faa49c7a9d87871a50c0fcc20db7f0888b938f2453-qhcMIs_fw1200webp",
      "https://gd-hbimg.huaban.com/593157e957ece7c2b609cff29e4ef0d1fa2c4811256c-jQNVjf_fw1200webp",
      "https://gd-hbimg.huaban.com/df04cb822b0269e7aa93452e02618a91216517002234-mWBRe4_fw1200webp",
    ],
    hotel: [
      "https://gd-hbimg.huaban.com/593157e957ece7c2b609cff29e4ef0d1fa2c4811256c-jQNVjf_fw1200webp",
      "https://gd-hbimg.huaban.com/4408ce7dabfe70d8953b81188d883c317da85cf9dc9-TXj4WM_fw1200webp",
      "https://gd-hbimg.huaban.com/825abfcea61f2de03b05e3dd93cc729a42b8e3ca1dd3-QF4I4i_fw1200webp",
    ],
    dining: [
      "https://gd-hbimg.huaban.com/37d77232b4610b68a3c97cd7bb5f3104eb13451d218a-Zyu2Bk_fw1200webp",
      "https://gd-hbimg.huaban.com/8a955615c902e151e74d6aef3f2ac6c3985126401bf8-oeWkhU_fw1200webp",
      "https://gd-hbimg.huaban.com/f88a337185faf98874d1025330d2bbb69976cc0c1634-i1ve96_fw1200webp",
    ],
    camera: [
      "https://gd-hbimg.huaban.com/e305483e190959e2cabb8be52ca79fd928a24cfa2f26-3GrnwP_fw1200webp",
      "https://gd-hbimg.huaban.com/f5ab64be086f53f76f362024b974fd7bdb6b248b180a-GktvNc_fw1200webp",
      "https://gd-hbimg.huaban.com/2a3eaae2c3eb94ca14140c0387d8b61e3eae34ba1ea7-Gi8Q7S_fw1200webp",
    ]
  };

}

const Duration defaultTime = const Duration(seconds: 10);

DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

