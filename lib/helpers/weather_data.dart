
class WeatherData {
  WeatherData({
      this.status, 
      this.count, 
      this.info, 
      this.infocode, 
      this.lives,});

  WeatherData.fromJson(dynamic json) {
    status = json['status'];
    count = json['count'];
    info = json['info'];
    infocode = json['infocode'];
    if (json['lives'] != null) {
      lives = [];
      json['lives'].forEach((v) {
        lives?.add(Lives.fromJson(v));
      });
    }
  }
  String? status;
  String? count;
  String? info;
  String? infocode;
  List<Lives>? lives;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['count'] = count;
    map['info'] = info;
    map['infocode'] = infocode;
    if (lives != null) {
      map['lives'] = lives?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Lives {
  Lives({
      this.province, 
      this.city, 
      this.adcode, 
      this.weather, 
      this.temperature, 
      this.winddirection, 
      this.windpower, 
      this.humidity, 
      this.reporttime, 
      this.temperatureFloat, 
      this.humidityFloat,});

  Lives.fromJson(dynamic json) {
    province = json['province'];
    city = json['city'];
    adcode = json['adcode'];
    weather = json['weather'];
    temperature = json['temperature'];
    winddirection = json['winddirection'];
    windpower = json['windpower'];
    humidity = json['humidity'];
    reporttime = json['reporttime'];
    temperatureFloat = json['temperature_float'];
    humidityFloat = json['humidity_float'];
  }
  String? province;
  String? city;
  String? adcode;
  String? weather;
  String? temperature;
  String? winddirection;
  String? windpower;
  String? humidity;
  String? reporttime;
  String? temperatureFloat;
  String? humidityFloat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['province'] = province;
    map['city'] = city;
    map['adcode'] = adcode;
    map['weather'] = weather;
    map['temperature'] = temperature;
    map['winddirection'] = winddirection;
    map['windpower'] = windpower;
    map['humidity'] = humidity;
    map['reporttime'] = reporttime;
    map['temperature_float'] = temperatureFloat;
    map['humidity_float'] = humidityFloat;
    return map;
  }

}