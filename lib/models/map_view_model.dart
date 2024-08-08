import 'package:flutter/cupertino.dart';
import 'package:intellij_tourism_designer/helpers/tile_providers.dart';

class MapViewModel with ChangeNotifier{

  String mapProvider = MapServiceProvider.gaode;
  List<bool> poiMarker = [false, false, false, false];
  List<bool> thematicMap = [false];

  void changeBaseLayer(String provider){
    mapProvider = provider;
    notifyListeners();
  }

}