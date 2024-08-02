import 'package:intellij_tourism_designer/helpers/POI_builder.dart';
import 'package:intellij_tourism_designer/helpers/itinerary_builder.dart';
// ignore_for_file: constant_identifier_names: 关闭对这个文件的代码风格检查
const double MINZOOM = 5.0;
const double MAXZOOM = 18.0;



Activity sampleAct =
    Activity(point: POI(), start: DateTime(2000), duration: const Duration());
Itinerary sampleIti = Itinerary(name: "新建行程", wayPoints: [
  POI(),
  POI(),
  POI(),
  POI(),
  POI()
],pathModes: [
  0,
  0,
  0,
  0
], days: [
  [sampleAct, sampleAct, sampleAct],
  [sampleAct, sampleAct, sampleAct],
  [sampleAct, sampleAct, sampleAct]
], imageURLs: ["assets/Sample.png",
  "assets/Sample.png",
  "assets/Sample.png"
], weathers: [
  sampleWeather,
  sampleWeather,
  sampleWeather
]);

Weather sampleWeather = Weather(time: DateTime(2000), weather: "Sunny");

Comment sampleCon = Comment(
    userName: "User",
    content: "好啊好啊",
    time: DateTime(2000),
    imageURL: ["assets/Sample.png", "assets/Sample.png", "assets/Sample.png"]);


class POItype{
  POItype._();

  static const String attraction = "旅游景点";
  static const String dining = "餐饮美食";
  static const String hotel = "酒店住宿";
  static const String camera = "机位信息";
}