import 'package:flutter/material.dart';
import 'entrances/mobile.dart';
import 'entrances/web.dart';
import 'http/dio_instance.dart';

void main() {
  Dio_ours.instance().initDio(baseUrl: "http://121.41.170.185:5000/");
  Dio_gaode.instance().initDio(baseUrl: "https://restapi.amap.com/v3");
  runApp(const MoblieApp());
  //runApp(const WebApp());
}