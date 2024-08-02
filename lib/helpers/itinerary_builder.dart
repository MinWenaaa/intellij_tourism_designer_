import 'package:intellij_tourism_designer/helpers/POI_builder.dart';

class Activity {
  POI point;
  DateTime start;
  Duration duration;

  Activity({required this.point, required this.start, required this.duration});
}

class Itinerary {
  String name;

  List<POI> wayPoints;
  List<int> pathModes;
  List<String> imageURLs;

  List<List<Activity>> days;
  List<Weather> weathers;

  Itinerary(
      {required this.name,
      required this.wayPoints,
      required this.pathModes,
      required this.days,
      required this.imageURLs,
      required this.weathers});
}

class Weather {
  DateTime time;
  String weather;

  Weather({required this.time, required this.weather});
}

class Comment {
  String userName;
  String content;
  DateTime time;
  List<String> imageURL;

  Comment(
      {required this.userName,
        required this.content,
        required this.time,
        required this.imageURL});
}