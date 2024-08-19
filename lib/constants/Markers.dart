import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:latlong2/latlong.dart';

Marker deepSecondaryMarker(LatLng point){
  return Marker(
      width: 40, height: 40,
      point: point,
      alignment: Alignment.topCenter,
      child: Icon(Icons.location_on_sharp, color: AppColors.deepSecondary)
  );
}

Polyline planPolyline(List<LatLng> points,){
  return Polyline(
        points: points,
        color: AppColors.secondary,
        strokeWidth: 4,
    borderStrokeWidth: 1,
    borderColor: AppColors.deepSecondary
  );
}

