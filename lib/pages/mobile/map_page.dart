import 'package:flutter/cupertino.dart';
import 'package:intellij_tourism_designer/widgets/map_view.dart';

/*
  地图查看模块
 */

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return DemoMap();
  }
}
