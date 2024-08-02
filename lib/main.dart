import 'package:flutter/material.dart';
import 'entrances/mobile.dart';
import 'entrances/web.dart';
import 'http/dio_instance.dart';

void main() {
  DioInstance.instance().initDio(baseUrl: "http://182.92.251.24:5000/");
  runApp(const MoblieApp());
  //runApp(const WebApp());
}