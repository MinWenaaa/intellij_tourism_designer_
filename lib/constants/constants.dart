
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

  static const poi_icon_url = [
    "https://gd-hbimg.huaban.com/33a7b811d0e36b0605deaeb7d93b583d18efb05d1a7d-oWSGNy_fw1200webp",
    "https://gd-hbimg.huaban.com/8a3b181a9aeea66947a1e1f1afdced36e60848f41960-ipRuLh_fw1200webp",
    "https://gd-hbimg.huaban.com/8b7d86785d2e648c7428e89e71837a036585c31b1a7c-Z2086e_fw1200webp",
    "https://gd-hbimg.huaban.com/f5d37faa10c52475039ecef5ecfe000c29f5a6241a87-CTZred_fw1200webp",
  ];

}

const Duration defaultTime = const Duration(seconds: 5);