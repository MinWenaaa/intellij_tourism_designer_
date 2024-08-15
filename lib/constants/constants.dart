
const double MINZOOM = 5.0;
const double MAXZOOM = 18.0;

class ConstantString{
  ConstantString._();

  static const String attraction = "旅游景点";
  static const String dining = "餐饮美食";
  static const String hotel = "酒店住宿";
  static const String camera = "机位信息";

  static const List<String> poi_layer = [
    "wuhan_attraction_poi",
    "wuhan_hotel_poi",
    "wuhan_",
    "wuhan_"
  ];

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


}

const Duration defaultTime = const Duration(seconds: 10);