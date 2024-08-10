import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/widgets/tools_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/locations.dart';
import 'package:intellij_tourism_designer/helpers/tile_providers.dart';
import 'package:provider/provider.dart';

/*
 基本地图视图
*/


class MapAnimation{
  //用于判断地图移动的状态从而优化地图移动的动画
  MapAnimation._();

  static const startedId = 'AnimatedMapController#MoveStarted';
  static const inProgressId = 'AnimatedMapController#MoveInProgress';
  static const finishedId = 'AnimatedMapController#MoveFinished';

}

class DemoMap extends StatefulWidget {
  const DemoMap({super.key});
  @override
  State<DemoMap> createState() => _WelcomeState();
}

class _WelcomeState extends State<DemoMap> with TickerProviderStateMixin {

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
          // unlimit the map range
          const LatLng(-90, -180),
          const LatLng(90, 180),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          recordCenter(context),
          FlutterMap(
            mapController: _mapController,
            options: initMapOption(),
            children: [
              Selector<GlobalModel, int>(
                selector: (context, provider) => provider.baseProvider,
                builder: (context, data, child) => baseTileLayer(data),
              ),
              //WMS_ours(layerName: "240720"),
              //WCS_ours(layerName: "usa"),
              freePlanPointMarker(),
              freePlanRoute()
          /*
              ...List.generate(4, (index) =>
                Selector<MapViewModel, bool>(
                  selector: (context, provider) => provider.thematicMap[index],
                  builder: (context, flag, child) => flag ?
                    WMS_ours(layerName: MapServiceProvider.thematicLayerName[index]) : const SizedBox(),
                )
              ),

              ...List.generate(4, (index) =>
                  Selector<MapViewModel, bool>(
                    selector: (context, provider) => provider.thematicMap[index],
                    builder: (context, flag, child) => flag ?
                    WMS_ours(layerName: MapServiceProvider.thematicLayerName[index]) : const SizedBox(),
                  )
              )*/

            ],
          ),
        ],
      );
    });
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = _mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$MapAnimation.startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = MapAnimation.finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = MapAnimation.inProgressId;
      }

      hasTriggeredMove |= _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  //记录当前中心，请求导航，非显示组件
  Widget recordCenter(BuildContext context){
    print("rebuild map view - sizedbox");
    final vm = Provider.of<GlobalModel>(context,listen: false);

    return Selector<GlobalModel, bool>(
      selector: (context, provider) => provider.recordCenter,
      builder: (context, flag, child) {
        print("call sizedbox selector builder");
        LatLng temp = _mapController.camera.center;
        print("get center of map: $temp");
        vm.addPoint(temp);
        return const SizedBox();
      }
    );
  }

  Widget freePlanPointMarker(){
    print("marker layer rebuild");
    return Selector<GlobalModel, List<LatLng>>(
      selector: (context, provider) => provider.points,
      builder: (context, data, child) => MarkerLayer(
        markers: List.generate(data.length,
                (index) => deepSecondaryMarker(data[index]))

      )
    );
  }

  Widget freePlanRoute(){
    print("route layer rebuild");
    return Selector<GlobalModel, List<LatLng>>(
        selector: (context, provider) => provider.Route,
        builder: (context, data, child) => PolylineLayer(polylines: [planPolyline(data)])

    );
  }
}
