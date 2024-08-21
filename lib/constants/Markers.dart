import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:latlong2/latlong.dart';

Marker deepSecondaryMarker(LatLng point){
  return Marker(
      width: 48, height: 48,
      point: point,
      alignment: Alignment.topCenter,
      child: Image.network(ConstantString.poi_icon_url[5], fit: BoxFit.fill,)
  );
}


Polyline planPolyline(List<LatLng> points,){
  return Polyline(
      points: points,
      color: AppColors.secondary,
      strokeWidth: 5,
      borderColor: AppColors.deepSecondary,
      borderStrokeWidth: 1.5
  );
}