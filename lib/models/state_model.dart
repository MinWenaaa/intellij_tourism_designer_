import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/http/Api.dart';

import '../helpers/geoPolygon.dart';

class StateModel with ChangeNotifier{

  List<Polygon<int>> listPolygon = [];

  Future<void> init() async {
    List<Features> features = await Api.instance.readLocalJson();
    listPolygon = List.generate(features.length, (index) => Polygon<int>(
      points: features[index].coordinates??[],
      color: AppColors.secondary,
      borderStrokeWidth: 3, borderColor: AppColors.highlight,
      hitValue: index,
      )
    );

    //print(lisPolygon.first.coordinates);
    notifyListeners();
  }
}