/// code : "200"
/// updateTime : "2024-08-11T21:02+08:00"
/// fxLink : "https://www.qweather.com/weather/hongshan-101200113.html"
/// now : {"obsTime":"2024-08-11T21:00+08:00","temp":"28","feelsLike":"32","icon":"151","text":"多云","wind360":"0","windDir":"北风","windScale":"0","windSpeed":"0","humidity":"74","precip":"0.0","pressure":"997","vis":"14","cloud":"100","dew":"23"}
/// refer : {"sources":["QWeather"],"license":["CC BY-SA 4.0"]}

class WeatherData {
  WeatherData({
      this.code, 
      this.updateTime, 
      this.fxLink, 
      this.now, 
      this.refer,});

  WeatherData.fromJson(dynamic json) {
    code = json['code'];
    updateTime = json['updateTime'];
    fxLink = json['fxLink'];
    now = json['now'] != null ? Now.fromJson(json['now']) : null;
    refer = json['refer'] != null ? Refer.fromJson(json['refer']) : null;
  }
  String? code;
  String? updateTime;
  String? fxLink;
  Now? now;
  Refer? refer;
  String? sunrise;
  String? sunset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['updateTime'] = updateTime;
    map['fxLink'] = fxLink;
    if (now != null) {
      map['now'] = now?.toJson();
    }
    if (refer != null) {
      map['refer'] = refer?.toJson();
    }
    return map;
  }

}

/// sources : ["QWeather"]
/// license : ["CC BY-SA 4.0"]

class Refer {
  Refer({
      this.sources, 
      this.license,});

  Refer.fromJson(dynamic json) {
    sources = json['sources'] != null ? json['sources'].cast<String>() : [];
    license = json['license'] != null ? json['license'].cast<String>() : [];
  }
  List<String>? sources;
  List<String>? license;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sources'] = sources;
    map['license'] = license;
    return map;
  }

}

/// obsTime : "2024-08-11T21:00+08:00"
/// temp : "28"
/// feelsLike : "32"
/// icon : "151"
/// text : "多云"
/// wind360 : "0"
/// windDir : "北风"
/// windScale : "0"
/// windSpeed : "0"
/// humidity : "74"
/// precip : "0.0"
/// pressure : "997"
/// vis : "14"
/// cloud : "100"
/// dew : "23"

class Now {
  Now({
      this.obsTime, 
      this.temp, 
      this.feelsLike, 
      this.icon, 
      this.text, 
      this.wind360, 
      this.windDir, 
      this.windScale, 
      this.windSpeed, 
      this.humidity, 
      this.precip, 
      this.pressure, 
      this.vis, 
      this.cloud, 
      this.dew,});

  Now.fromJson(dynamic json) {
    obsTime = json['obsTime'];
    temp = json['temp'];
    feelsLike = json['feelsLike'];
    icon = json['icon'];
    text = json['text'];
    wind360 = json['wind360'];
    windDir = json['windDir'];
    windScale = json['windScale'];
    windSpeed = json['windSpeed'];
    humidity = json['humidity'];
    precip = json['precip'];
    pressure = json['pressure'];
    vis = json['vis'];
    cloud = json['cloud'];
    dew = json['dew'];
  }
  String? obsTime;
  String? temp;
  String? feelsLike;
  String? icon;
  String? text;
  String? wind360;
  String? windDir;
  String? windScale;
  String? windSpeed;
  String? humidity;
  String? precip;
  String? pressure;
  String? vis;
  String? cloud;
  String? dew;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['obsTime'] = obsTime;
    map['temp'] = temp;
    map['feelsLike'] = feelsLike;
    map['icon'] = icon;
    map['text'] = text;
    map['wind360'] = wind360;
    map['windDir'] = windDir;
    map['windScale'] = windScale;
    map['windSpeed'] = windSpeed;
    map['humidity'] = humidity;
    map['precip'] = precip;
    map['pressure'] = pressure;
    map['vis'] = vis;
    map['cloud'] = cloud;
    map['dew'] = dew;
    return map;
  }

}


/// code : "200"
/// updateTime : "2021-02-17T11:00+08:00"
/// fxLink : "http://hfx.link/2ax1"
/// sunrise : "2021-02-20T06:58+08:00"
/// sunset : "2021-02-20T17:57+08:00"
/// refer : {"sources":["QWeather"],"license":["QWeather Developers License"]}

class Sun {
  Sun({
    this.code,
    this.updateTime,
    this.fxLink,
    this.sunrise,
    this.sunset,
    this.refer,});

  Sun.fromJson(dynamic json) {
    code = json['code'];
    updateTime = json['updateTime'];
    fxLink = json['fxLink'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    refer = json['refer'] != null ? Refer.fromJson(json['refer']) : null;
  }
  String? code;
  String? updateTime;
  String? fxLink;
  String? sunrise;
  String? sunset;
  Refer? refer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['updateTime'] = updateTime;
    map['fxLink'] = fxLink;
    map['sunrise'] = sunrise;
    map['sunset'] = sunset;
    if (refer != null) {
      map['refer'] = refer?.toJson();
    }
    return map;
  }

}