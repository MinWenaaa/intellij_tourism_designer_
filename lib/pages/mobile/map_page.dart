import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/pages/poi_detail_page.dart';
import 'package:intellij_tourism_designer/widgets/tools_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../helpers/tile_providers.dart';
import '../../widgets/searching_bar.dart';

/*
  地图查看模块
 */


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin{


  Timer? _timer;
  late final MapController _mapController;



  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startTimer(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  void _startTimer(BuildContext context) {

    final vm = Provider.of<GlobalModel>(context,listen: false);
    _timer = Timer.periodic(defaultTime, (timer) {
      LatLng newCenter = _mapController.camera.center;
      print("check center move: ${newCenter}");
      vm.refreshMarker(newCenter);
    });
  }


  MapOptions initMapOption() {
    return MapOptions(
      initialCenter: LatLng(30.5,114.4),
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
    return Scaffold(
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
                    Selector<GlobalModel, List<Marker>>(
                      selector: (context, provider) => provider.markers[0],
                      builder: (context, data, child) => MarkerLayer(markers: data),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: primaryInkWell(
                      callback: () {},
                      text: "开始记录",
                    ),
                  )
                ),
                ToolsButton(),
                SearchingBar(),
                _PoiDetailFab(context)
                /*Positioned(
                  top: 80, right: 10,
                  child: WeatherCard(
                    height: 80, width: 80,
                    location: LatLng(30.56,114.32)
                  ),
                )*/
              ],
            )
        )
    );
  }


  Widget _PoiDetailFab(BuildContext context){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Selector<GlobalModel, mapState>(
      selector: (context, provider) => provider.state,
      builder: (context, data, child) => (data==mapState.detail) ?
          Stack(children: [
              Poidetailpage(id: vm.currentPOI),
              Positioned(
                top: 10, left: 10,
                child: GestureDetector(
                    onTap: () => vm.changeState(mapState.map),
                    child: Icon(Icons.arrow_back_ios, color: AppColors.matter,)),
              )],
          ) : SizedBox()
    );
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

}


class MapAnimation{
  //用于判断地图移动的状态从而优化地图移动的动画
  MapAnimation._();

  static const startedId = 'AnimatedMapController#MoveStarted';
  static const inProgressId = 'AnimatedMapController#MoveInProgress';
  static const finishedId = 'AnimatedMapController#MoveFinished';

}

