import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/pages/poi_detail_page.dart';
import 'package:intellij_tourism_designer/widgets/buttom_sheet.dart';
import 'package:intellij_tourism_designer/widgets/tools_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../helpers/tile_providers.dart';
import '../../widgets/detail_view.dart';
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
    _startTimer();
  }

  @override
  void dispose() {
    print("MapPage.timer Canceled");
    _timer?.cancel();
    super.dispose();
  }


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

    return Scaffold(
        body: SafeArea(
            child: Row(
              children: [
                Selector<GlobalModel, mapState>(
                  selector: (context, provider) => provider.state,
                  builder: (context, state, child) => state!=mapState.map ? Flexible(
                    flex: 3,
                    child: Selector<GlobalModel, int>(
                        selector: (context, provider) => provider.currentPOI,
                        builder: (context, id, child) => Stack(
                          children: [
                            Visibility(
                              visible: state==mapState.detail,
                              child: Poidetailpage(id: id),
                            ),
                            Visibility(
                              visible: state==mapState.detail,
                              child: Positioned(
                                top: 12, left: 12,
                                child: GestureDetector(
                                  child: Icon(Icons.arrow_back_ios),
                                  onTap: () => vm.changeState(mapState.map),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: state==mapState.record,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: LayerSettingDemo(height: double.infinity,),
                              )
                            ),
                            Visibility(
                              visible: state==mapState.record,
                              child: Positioned(
                                top: 12, left: 12,
                                child: GestureDetector(
                                  child: Icon(Icons.arrow_back_ios),
                                  onTap: () => vm.changeState(mapState.map)
                                 ),
                              ),)
                          ],
                        ),
                      )
                  ): const SizedBox()
                ),
                Flexible(
                  flex: 5,
                  child: Stack(
                    children: [
                      _mapLayers(),

                      //_weatherCard(),
                      //_toolsButton(context),
                      //_searchBar(context),
                      //_recordButton(),
                      //_stopRecord(),
                      //_PoiDetailFab(context),
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }

  Widget _mapLayers(){

    final vm = Provider.of<GlobalModel>(context,listen: false);

    return FlutterMap(
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
        ),
        Selector<GlobalModel,mapState>(
            selector: (context, provider) => provider.state,
            builder: (context, data, child) => (data==mapState.view_record)?
            Selector<GlobalModel,List<LatLng>>(
                selector: (context, provider) => provider.recordLine,
                builder: (context, data, child) {
                  _animatedMapMove(data[0], 16.5);
                  return PolylineLayer(polylines: [planPolyline(data)]);
                }
            ) : const SizedBox()
        ),
        Align(
            alignment: Alignment.topRight,
            child: SizedBox(
                width: 480,
                child: SearchingBar(callBack: _animatedMapMove,))
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.settings, size: 36, color: AppColors.primary,),
                onTap: () => vm.changeState(mapState.record)
              ),
            )
        )
      ],
    );
  }

  Widget _weatherCard(){
    return Selector<GlobalModel, mapState>(
      selector: (context, model) => model.state,
      builder: (context, state, child) => Positioned(
          top: state==mapState.map ? 80 : 10, right: 10,
          child: const WeatherText(
              height: 180, width: 280,
              location: LatLng(30.56,114.32)
          )
      ),
    );
  }

  Widget _toolsButton(BuildContext context){
    return Selector<GlobalModel, mapState>(
        selector: (context, model) => model.state,
        builder: (context, state, child) => state==mapState.map ?
        const ToolsButton() : const SizedBox()
    );
  }

  Widget _searchBar(BuildContext context){
    return Selector<GlobalModel, mapState>(
        selector: (context, model) => model.state,
        builder: (context, state, child) => state==mapState.map ?
        SearchingBar(callBack: _animatedMapMove) : const SizedBox()
    );
  }

  Widget _recordButton(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Selector<GlobalModel, mapState>(
        selector: (context, model) => model.state,
        builder: (context, state, child) => state==mapState.map ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: primaryInkWell(
                callback: () => vm.changeState(mapState.record),
                text: "开始记录",
              ),
            )
        ) : const SizedBox()
    );
  }

  Widget _stopRecord(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Selector<GlobalModel, mapState>(
        selector: (context, model) => model.state,
        builder: (context, state, child) => state==mapState.record ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: primaryInkWell(
                callback: () => vm.changeState(mapState.map),
                text: "结束",
              ),
            )
        ) : const SizedBox()
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
                child: const Icon(Icons.arrow_back_ios, color: AppColors.matter,)),
          )],
        ) : const SizedBox()
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

