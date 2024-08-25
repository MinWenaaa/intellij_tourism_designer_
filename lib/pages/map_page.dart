import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intellij_tourism_designer/constants/Markers.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/widgets/event_page.dart';
import 'package:intellij_tourism_designer/pages/poi_detail_page.dart';
import 'package:intellij_tourism_designer/widgets/tools_button.dart';
import 'package:intellij_tourism_designer/widgets/upload_event.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../helpers/record_list_data.dart';
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

  bool loadEvent = false;
  late LatLng geolocation;


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

    _timer = Timer.periodic(defaultTime, (timer) async {
      LatLng newCenter = _mapController.camera.center;
      print("check center move: ${newCenter}");
      if( (vm.lastRefreshCenter.latitude - newCenter.latitude).abs() > 0.025 &&
          (vm.lastRefreshCenter.longitude - newCenter.longitude).abs() > 0.025 ) {
        vm.refreshMarker(newCenter);
      }
      if(vm.state==mapState.record){
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        geolocation= LatLng(position.latitude, position.longitude);
        Api.instance.pushPoint(vm.rid, geolocation);
        vm.pushPoint(geolocation);
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
          child: Stack(
              children: [
                _mapLayers(),
                _weatherCard(),
                _toolsButton(context),
                _searchBar(context),
                _recordButton(),
                _stopRecord(),
                _PoiDetailFab(context),
                _backButton(),
                loadEvent ? upLoadEvent(
                  point: _mapController.camera.center,
                  rid: vm.rid,
                  back: ()=> setState((){loadEvent = false;},)
                ): const SizedBox(),
                _view_Event()
              ],
            )
        )
    );
  }

  Widget _mapLayers(){
    return FlutterMap(
      mapController: _mapController,
      options: initMapOption(),
      children: [
        Selector<GlobalModel, int>(
          selector: (context, provider) => provider.baseProvider,
          builder: (context, data, child) => baseTileLayer(data),
        ),
        Selector<GlobalModel, int>(
          selector: (context, provider) => provider.showSunset,
          builder: (context, data, child) =>
            data!=-1 ? WMS_ours(layerName: ConstantString.sunsetLayer[data]) : const SizedBox(),
        ),
        ..._HeatMap(),
        ..._Feature(),
        ..._markerLayer(),
        //Slector
        Selector<GlobalModel,mapState>(
          selector: (context, provider) => provider.state,
          builder: (context, data, child) => (data==mapState.view_record||data==mapState.record)?
            Selector<GlobalModel,List<LatLng>>(
            selector: (context, provider) => provider.recordLine,
            builder: (context, line, child) {
              print("MapPage.recordLayer: animated: ${line[0]}");
              _animatedMapMove(line[0], 16.5);
              return PolylineLayer(polylines: [planPolyline(line)]);
            }) : const SizedBox()
        ),
        Selector<GlobalModel,mapState>(
            selector: (context, provider) => provider.state,
            builder: (context, data, child) => (data==mapState.view_record||data==mapState.record)?
            Selector<GlobalModel,List<Marker>>(
                selector: (context, provider) => provider.recordMarker,
                builder: (context, data, child) {
                  return MarkerLayer(markers: data);
                }
            ) : const SizedBox()
        ),
        Selector<GlobalModel,mapState>(
          selector: (context, provider) => provider.state,
          builder: (context, data, child) => Visibility(
            visible: data==mapState.view_iti,
            child: Selector<GlobalModel,List<Polyline>>(
              selector: (context, provider) => provider.planPoints,
              builder: (context, data, child) {
                return PolylineLayer(polylines: data);
              }
            )
          )
        ),
        Selector<GlobalModel,mapState>(
            selector: (context, provider) => provider.state,
            builder: (context, data, child) => Visibility(
                visible: data==mapState.view_iti,
                child: Selector<GlobalModel,List<Marker>>(
                    selector: (context, provider) => provider.planMarker,
                    builder: (context, data, child) {
                      _animatedMapMove(data[0].point, 16.5);
                      return MarkerLayer(markers: data);
                    })
            )
        ),
      ],
    );
  }

  List<Widget> _markerLayer(){
    return List.generate(4, (index)=>Selector<GlobalModel, List<Marker>>(
      selector: (context, provider) => provider.markers[index],
      builder: (context, data, child) => MarkerLayer(markers: data),
    ),);
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

  Widget _weatherCard(){
    return Selector<GlobalModel, mapState>(
      selector: (context, model) => model.state,
      builder: (context, state, child) => Positioned(
          top: state==mapState.map ? 80 : 10, right: 10,
          child: WeatherText(
              height: 460.h, width: 720.w,
              location: const LatLng(30.56,114.32)
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
            padding: EdgeInsets.all(64.h),
            child: primaryInkWell(
              callback: () async {
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                geolocation = LatLng(position.latitude, position.longitude);
                vm.changeState(mapState.record);
              },
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
              padding: EdgeInsets.only(bottom: 64.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  primaryInkWell(
                    callback: () => vm.changeState(mapState.map),
                    text: "结束",
                    width: 420.w, height: 134.h,
                  ),
                  secondaryInkWell(
                    callback: () => setState(() {
                      loadEvent = true;
                    }),
                    text: "添加日记",
                    width: 420.w, height: 134.h,
                  )
                ],
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

  Widget _backButton(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Selector<GlobalModel, mapState>(
      selector: (context, provider) => provider.state,
      builder: (context, data, child) => Visibility(
        visible: data == mapState.view_record || data == mapState.view_iti,
        child: Positioned(
          top: 12, left: 12,
          child: GestureDetector(
            child: Icon(Icons.arrow_back_ios, size: 36,),
            onTap: () => vm.changeState(mapState.map),
        )),
      ),
    );
  }

  Widget _view_Event(){
    return Selector<GlobalModel, mapState>(
      selector: (context, provider) => provider.state,
      builder: (context, data, child) => Visibility(
        visible: data == mapState.view_event,
        child: Selector<GlobalModel, Events>(
          selector: (context, provider) => provider.currentEvent,
          builder: (context, data, child) => EventPage(event: data,)
        )
      ),
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

