import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/models/path_plan_model.dart';
import 'package:intellij_tourism_designer/models/plan_edit_model.dart';
import 'package:intellij_tourism_designer/widgets/path_query.dart';
import 'package:intellij_tourism_designer/widgets/poi_detail_page.dart';
import 'package:intellij_tourism_designer/widgets/layyer_setting.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../helpers/tile_providers.dart';
import '../widgets/detail_view.dart';
import '../widgets/searching_bar.dart';

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

  bool isNavigation = false;
  //0-Map，1-plan
  MapEvent? _tapMap;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startTimer();
  }

  @override
  void dispose() {
    print("MapPage.timer Canceled");
    _timer?.cancel();
    super.dispose();
  }

  PathPlanModel pathPlanModel = PathPlanModel();

  void _startTimer() {

    final vm = Provider.of<GlobalModel>(context,listen: false);

    _timer = Timer.periodic(defaultTime, (timer) {
      LatLng newCenter = _mapController.camera.center;
      print("Map Map check center move: ${newCenter}  ${vm.mapIndex}");
      if( vm.mapIndex &&((vm.lastRefreshCenter.latitude - newCenter.latitude).abs() > 0.025 ||
          (vm.lastRefreshCenter.longitude - newCenter.longitude).abs() > 0.025) ) {
        vm.refreshMarker(newCenter,radius: 0.05);
      }
    });
  }


  MapOptions initMapOption() {
    return MapOptions(
      onTap: (tapPosition, geolocation) {pathPlanModel.addPoint(geolocation);
        print("Map tap: add point $geolocation");},
      initialCenter: const LatLng(30.5,114.4),
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

    final vm = Provider.of<GlobalModel>(context,listen: false);

    return ChangeNotifierProvider<PathPlanModel>(
      create: (context) => pathPlanModel,
      child: Row(
        children: [
          Selector<GlobalModel, List<bool>>(
            selector: (context, provider) => provider.state,
            builder: (context, state, child) => Visibility(
              visible: state[0]||state[1]||isNavigation,
              child: Flexible(
                flex: 3,
                child: Stack(
                  children: [
                    _detailView(state[1]),
                    Visibility(
                      visible: state[0],
                      child: LayerSettingDemo(),
                    ),
                    Visibility(
                      visible: isNavigation,
                      child: PathQueryWidget(
                        back: ()=>setState(() {
                          isNavigation = false;
                        }),
                        move: _animatedMapMove,
                      ),
                    )
                  ],
                )
              ),
            )
          ),
          Flexible(
            flex: 5,
            child: Stack(
              children: [
                _mapLayers(),
                _weatherCard(),
                _searchBar(),
                _Buttons()
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _Buttons(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 128,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  child: Text("导航", style: AppText.whiteHead,),
                  onPressed: () => setState(() {
                    isNavigation = true;
                  }),
                ),
                FloatingActionButton(
                    backgroundColor: AppColors.secondary,
                    child: Icon(Icons.settings, size: 36, color: AppColors.deepSecondary,),
                    onPressed: () => vm.changeSetting(true)
                ),
              ],
            ),
          ),
        )
    );
  }


  Widget _detailView(bool show){
    return Selector<GlobalModel, int>(
      selector: (context, provider) => provider.currentPOI,
      builder: (context, poi, child) => Visibility(
        visible: show,
        child: Poidetailpage(id: poi,),
      )
    );
  }

  Widget _mapLayers(){

    return FlutterMap(
      mapController: _mapController,
      options: initMapOption(),
      children: [
        _baseLayer(),
        _sunSetLayer(),
        ..._HeatMap(),
        ..._Feature(),
        ..._markerLayer(),
        _planMarker(),
        _planRouteLayer()
      ],
    );
  }

  Widget _baseLayer(){
    return Selector<GlobalModel, int>(
      selector: (context, provider) => provider.baseProvider,
      builder: (context, data, child) => baseTileLayer(data),
    );
  }

  List<Widget> _HeatMap(){
    return List.generate(4, (index)=>Selector<GlobalModel, bool>(
      selector: (context, provider) => provider.showHeatMap[index],
      builder: (context, data, child) => data ? WMS_ours(layerName: ConstantString.heatMap[index]) : const SizedBox(),
    ),);
  }

  List<Widget> _Feature(){
    return List.generate(5, (index) => Selector<GlobalModel, bool>(
      selector: (context, provider) => provider.showFeatureMap[index],
      builder: (context, data, child) => data ? WMS_ours(layerName: ConstantString.featureLayer[index]) : const SizedBox(),
    ),);
  }

  List<Widget> _markerLayer(){
    return List.generate(4, (index)=>Selector<GlobalModel, List<Marker>>(
    selector: (context, provider) => provider.markers[index],
    builder: (context, data, child) => MarkerLayer(markers: data),
    ),);
  }

  Widget _planRouteLayer(){
    return Selector<PathPlanModel, List<Polyline>>(
      selector: (context, provider) => provider.Route,
      builder: (context, data, child) => PolylineLayer(polylines: data)
    );
  }

  Widget _planMarker(){
    return Selector<PathPlanModel, List<Marker>>(
        selector: (context, provider) => provider.markers,
        builder: (context, data, child) => MarkerLayer(markers: data)
    );
  }



  Widget _sunSetLayer(){
    return Selector<GlobalModel, int>(
      selector: (context, provider) => provider.showSunset,
      builder: (context, data, child) =>
      data!=-1 ? WMS_ours(layerName: ConstantString.sunsetLayer[data]) : const SizedBox(),
    );
  }

  Widget _weatherCard(){
    return const Positioned(
      top: 80, right: 10,
      child: WeatherText(
        height: 180, width: 280,
        location: LatLng(30.56,114.32)
      ),
    );
  }


  Widget _searchBar(){
    return Align(
        alignment: Alignment.topRight,
        child: SizedBox(
            width: 480,
            child: SearchingBar(callBack: _animatedMapMove,))
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

