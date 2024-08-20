import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/models/path_plan_model.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/helpers/tile_providers.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';

/*
路径规划页面
 */


class PathPlanningPage extends StatefulWidget {
  const PathPlanningPage({super.key});
  @override
  State<PathPlanningPage> createState() => _WelcomeState();
}

class _WelcomeState extends State<PathPlanningPage> with TickerProviderStateMixin {

  PathPlanModel pathPlanModel = PathPlanModel();
  late final MapController _mapController; //地图视角控制器

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  MapOptions initMapOption() {
    return MapOptions(
      initialCenter: LatLng(30.56,114.32),
      initialZoom: 16.5,
      maxZoom: MAXZOOM,
      minZoom: MINZOOM,
      cameraConstraint: CameraConstraint.contain(
        bounds: LatLngBounds(
          const LatLng(-90, -180),
          const LatLng(90, 180),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PathPlanModel>(
      create: (context) => pathPlanModel,
      child: Scaffold(
      body: SafeArea(
          child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: initMapOption(),
                  children: [
                    Selector<GlobalModel, int>(
                      selector: (context, provider) => provider.baseProvider,
                      builder: (context, data, child) => baseTileLayer(data),
                    ),
                    Selector<PathPlanModel, List<LatLng>>(
                      selector: (context, provider) => provider.Route,
                      builder: (context, data, child) {
                        print(data);
                        return PolylineLayer(polylines: [planPolyline(data)]);
                      }
                    ),
                    Selector<PathPlanModel, List<Marker>>(
                        selector: (context, provider) => provider.markers,
                        builder: (context, data, child) {
                          return MarkerLayer(
                              markers: data
                          );
                        }
                    ),
                    _Buttons(),
                    Align(
                      alignment: Alignment.center,
                      child: Image.network(ConstantString.poi_icon_url[4], width: 144.r, height: 144.r,)
                    ),
                  ],
                ),
              ]
            ),
          )
        ),
    );
  }


  Widget _Buttons(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 64.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            secondaryInkWell(
              callback: () => pathPlanModel.addPoint(_mapController.camera.center),
              text:"添加",
              width: 420.w, height: 134.h,
            ),
            primaryInkWell(
               callback: () => RouteUtils.pop(context),
               text: "完成",
               width: 420.w, height: 134.h,
            )
          ]
        ),
      )
    );
  }

}




