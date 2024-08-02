class POI {
  double lat, lng;
  String Name;
  String type;
  int area;
  String info;
  String location;
  String ImageURL;

  POI(
      {this.lat = 0,
        this.lng = 0,
        this.Name = "？未知地点",
        this.type = "NONE",
        this.area = -1,
        this.info = "暂无介绍，请！勇！敢！探！索！",
        this.location = "....?",
        this.ImageURL = "assets/imgs/Sample.png"});
}


class POIcard{
  final POI info;
  const POIcard(POI poi):
        info=poi;

  @override
  String toString() {
    return 'POIcard{info: $info}';
  }
}