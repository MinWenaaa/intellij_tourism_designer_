import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/poi_list_view_data.dart';
import 'package:intellij_tourism_designer/models/plan_edit_model.dart';
import 'package:intellij_tourism_designer/widgets/layyer_setting.dart';
import 'package:intellij_tourism_designer/widgets/calendar.dart';
import 'package:latlong2/latlong.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../helpers/tile_providers.dart';
import '../models/global_model.dart';
import '../widgets/Iti_edit.dart';
import '../widgets/searching_bar.dart';
import 'map_page.dart';

//行程规划模块

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> with TickerProviderStateMixin{

  Timer? _timer;

  bool setting = false;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();


  bool _showTextField = false;
  final TextEditingController _textController = TextEditingController();
  String requirement = "";

  late final MapController _mapController;


  void initState() {
    super.initState();
    _mapController = MapController();
    _startTimer();
  }

  void _startTimer() {

    final vm = Provider.of<GlobalModel>(context,listen: false);

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      LatLng newCenter = _mapController.camera.center;
      print("MapItinerary: check center move: ${newCenter}  ${!vm.mapIndex}");
      if( !vm.mapIndex &&((vm.lastRefreshCenter.latitude - newCenter.latitude).abs() > 0.025 ||
          (vm.lastRefreshCenter.longitude - newCenter.longitude).abs() > 0.025) ) {
        vm.refreshMarker(newCenter, radius: 0.05);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    //print(state);
    return Row(children: [
        Flexible(
          flex: 2,
          child: _operator()
        ),
        Flexible(
          flex: 3,
          child: MapPage()),
      ]
    );
  }

  Widget _operator(){
    return Selector<PlanEditModel, bool>(
      selector: (context, provider) => provider.isEditing,
      builder: (context, isEditing, child) => Stack(
         children:[
           Visibility(
              visible: !isEditing,
              child: _createFab()
          ),
           Visibility(
             visible: isEditing,
             child: ItiEditWidget(callBack: _animatedMapMove)
           ),
           Selector<GlobalModel, bool>(
             selector: (context, provider) => provider.state[0],
             builder: (context, state, child) => Visibility(
                 visible: state,
                 child: LayerSettingDemo(),
                 )
             ),
         ]
        )
    );
  }

  Widget _createFab(){
    final vm = Provider.of<PlanEditModel>(context,listen: false);
    final gm = Provider.of<GlobalModel>(context,listen: false);
    return Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24,),
          //Text("出发时间："),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: timeSelector(callBack: (value)=>start = value)
          ),
          //Text("结束时间："),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: timeSelector(callBack: (value)=>end = value)
          ),
          Expanded(child: SizedBox(),),
          Visibility(
            visible: !_showTextField,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  primaryInkWell(
                    width: 200,
                    callback: (){
                      requirement = "";
                      create();
                    },
                    text: "立即创建"),
                  secondaryInkWell(
                    width: 200,
                    callback: () => setState(() {
                      _showTextField = true;}),
                    text: "AI生成"),
              ]
            ),
          ),
          _aiDialog(),
          const SizedBox(height: 24,),
        ],
    );
  }


  Widget _aiDialog(){
    return Visibility(
        visible: _showTextField,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 380,
              child: TextField(
                controller: _textController,
                onChanged: (value) {
                  //print(value);
                  requirement = value;
                },
                style: const TextStyle(color: AppColors.deepSecondary, fontSize: 14),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.deepSecondary),
                  ),
                  icon: Image.network("https://gd-hbimg.huaban.com/c58333b7739ae05af800a79572295c1c7360fb5bade-o3kQFE_fw1200webp", width: 36, height: 36,),
                  hintText: "输入期待的旅游要求，大模型为您生成规划",
                  labelStyle: const TextStyle(color: AppColors.deepSecondary)
                ),
              ),
            ),
            Column(
              children: [
                TextButton(
                  onPressed: create,
                  child: Text("确定")),
                TextButton(
                  onPressed: () => setState(() {
                    _showTextField = false;
                    _textController.clear();
                  }),
                  child: Text("取消")
                ),
              ],
            )
          ],
        )

    );
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


  Widget MapPage(){
    final gm = Provider.of<GlobalModel>(context,listen: false);
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
        ...List.generate(4, (index)=>Selector<GlobalModel, List<Marker>>(
          selector: (context, provider) => provider.markers[index],
          builder: (context, data, child) => MarkerLayer(markers: data),
        ),),
        ...List.generate(4, (index)=>Selector<GlobalModel, bool>(
          selector: (context, provider) => provider.showHeatMap[index],
          builder: (context, data, child) => data ? WMS_ours(layerName: ConstantString.heatMap[index]) : const SizedBox(),
        ),),
        ...List.generate(5, (index) => Selector<GlobalModel, bool>(
          selector: (context, provider) => provider.showFeatureMap[index],
          builder: (context, data, child) => data ? WMS_ours(layerName: ConstantString.featureLayer[index]) : const SizedBox(),
        ),),
        Selector<PlanEditModel, List<Polyline>>(
          selector: (context, provider) => provider.route,
          builder: (context, data, child) {
            print("ItiPage Map: rebuild ${data.length} routes");
            return PolylineLayer(polylines: data);
          }
        ),
        Selector<PlanEditModel, List<Marker>>(
            selector: (context, provider) => provider.planMarker,
            builder: (context, data, child) {
              print("ItiPage Map: rebuild ${data.length} routes");
              return MarkerLayer(markers: data,);
            }
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
                child: const Icon(Icons.settings, size: 36, color: AppColors.primary,),
                onTap: () => gm.changeSetting(true)
              ),
            )
        ),
        _poiCard(),
      ],
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

  void create(){
    print(" sent data to model");
    final vm = Provider.of<PlanEditModel>(context,listen: false);
    final gm = Provider.of<GlobalModel>(context,listen: false);
    int num = (end.difference(start)).inDays+1;
    if(num<2){
      //print(" num < 2 : ${num}");
      OKToast( child: Text("选择更多天数"),);
    } else {
      vm.setData(start: start, num: num, require: requirement, userid: gm.user.uid??0, );
      vm.createPlan();
      vm.changeEditState(true);
    }
  }

  Widget _poiCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Selector<GlobalModel, bool>(
        selector: (context, provider) => provider.state[1],
        builder: (context, state, child) => Visibility(
          visible: state,
          child: Selector<GlobalModel, PoiListViewData?>(
              selector: (context, provider) => provider.itiMapCardData,
              builder: (context, data, child) => data==null ? const SizedBox(): _pushPosition(data)
          ),
        ),
      ),
    );
  }

  Widget _pushPosition(PoiListViewData poi) {
    Random random = Random();
    int randomNumber = random.nextInt(3);
    final vm = Provider.of<PlanEditModel>(context,listen: false);
    return Container(
      width: 720, height: 230,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(36)),
        color: Color(0xfffaf8ff),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      padding: EdgeInsets.only(top: 16, bottom: 16, right: 48, left: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 7,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6,),
                  Row(
                    children: [
                      Image.network(ConstantString.poiHeadIcon[poi.ptype]![randomNumber], width: 36, height: 36, fit: BoxFit.contain,),
                      const SizedBox(width: 12,),
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children:[Text("【${poi.ptype}】", style: AppText.detail,),
                        Text(poi.pname ?? "", style: AppText.Head1,overflow: TextOverflow.clip, maxLines: 2,),
                      ]),
                      const Expanded(child: SizedBox()),
                      Selector<GlobalModel, int>(
                        selector: (context, provider) => provider.currentPOI,
                        builder: (context, data, child) => TextButton(
                          onPressed: () => vm.pushLocation(id: data),
                          child: Icon(Icons.add, color: AppColors.primary, size: 32,),
                        )
                      ),
                      const SizedBox(width: 12,),
                    ],
                  ),
                  const SizedBox(height: 6,),
                  Text(poi.pintroduceShort ?? "",
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                    style: AppText.matter,),
                  const Expanded(child: SizedBox()),
                  Text(poi.paddress ?? "",
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: AppText.detail,
                  )
                ],
              ),
          ),
          Flexible(
              flex: 5,
              child: Image.network(poi.pphoto ??
                  "https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp",
                fit: BoxFit.cover,
                width: double.infinity, height: double.infinity,
              )
          )
        ],
      ),
    );
  }




}
