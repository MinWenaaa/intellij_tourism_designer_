import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/plan_edit_model.dart';
import 'package:intellij_tourism_designer/widgets/buttom_sheet.dart';
import 'package:intellij_tourism_designer/widgets/calendar.dart';
import 'package:latlong2/latlong.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../../constants/Markers.dart';
import '../../constants/constants.dart';
import '../../helpers/tile_providers.dart';
import '../../models/global_model.dart';
import '../../widgets/Iti_edit.dart';
import '../../widgets/searching_bar.dart';
import '../desktop/map_page.dart';

//行程规划模块

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> with TickerProviderStateMixin{

  int state = 0;
  // 0-创建；1-编辑；
  bool setting = false;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  int curDay = 0;

  bool _showTextField = false;
  final TextEditingController _textController = TextEditingController();
  String requirement = "";

  late final MapController _mapController;


  void initState() {
    super.initState();
    _mapController = MapController();
  }


  @override
  Widget build(BuildContext context) {
    //print(state);
    return Row(children: [
        _operator(),
        Flexible(
          flex: 5,
            child: MapPage()),
      ]
    );
  }

  Widget _operator(){
    return Flexible(
      flex: 3,
      child: Stack(
       children:[
         Visibility(
            visible: state==0 && !setting,
            child: _createFab()
        ),
         Visibility(
             visible: state==1 && !setting,
             child: ItiEditWidget(callback: callBack
             )
         ),
         Visibility(
             visible: setting,
             child: LayerSettingDemo(height: double.infinity,)
         ),
          Visibility(
              visible: setting,
              child: Align(
                alignment: Alignment.topLeft, child: GestureDetector(
                child: Icon(Icons.arrow_back_ios), onTap: () => setState(() {
                setting = false;
                }),),)),
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
                    callback: create,
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


  void callBack(){
    state = 0;
    setState(() {});
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
        Selector<PlanEditModel, List<List<LatLng>>>(
          selector: (context, provider) => provider.route,
          builder: (context, data, child) {
            print("route rebuild: ${data.length}");
            return PolylineLayer(polylines: List.generate(data.length, (index) =>
                planPolyline(data[index])));

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
                child: Icon(Icons.settings, size: 36, color: AppColors.primary,),
                onTap: () => setState(() {
                  setting = true;
                }),
              ),
            )
        )
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
      vm.setData(start: start, num: num, require: requirement, uid: gm.user.uid??0, );
      print(" set state : 1");
      state = 1;
    }
    setState(() {});
  }

}
