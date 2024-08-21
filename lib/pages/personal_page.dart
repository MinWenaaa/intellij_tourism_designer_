import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/pages/login_page.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/event_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../constants/Markers.dart';
import '../constants/constants.dart';
import '../constants/theme.dart';
import '../helpers/record_list_data.dart';
import '../helpers/tile_providers.dart';
import '../http/Api.dart';
import '../models/plan_edit_model.dart';
import '../widgets/iti_list_page.dart';
import '../widgets/memory_list_page.dart';

/*
  个人主页
*/

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key, required this.callBack});

  final Function callBack;

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> with TickerProviderStateMixin{

  int state = 0;
  //0-主页；1-查看回忆；2-日记详情
  Events currentEvent = Events();
  List<LatLng> recordLine = [];
  List<Marker> recordMarker = [];
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    //recordData = fetch(context);
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlanEditModel>(context,listen: false);
    return Stack(
        children: [
          Row(
            children: [
              Flexible(
                flex: 5,
                child: ItiListView(callBack: (data){
                  widget.callBack.call(2);
                  vm.changeEditState(true);
                  vm.readPlan(data.id);
                },),
              ),
              Flexible(
                flex: 5,
                child: MemoryListView(callBack: (data) => getRecordDetail(data.id))
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: _UserCard(context)
              ),
            ],
          ),
          state != 0 ? _mapView() : const SizedBox(),
          state != 0 ? Positioned(
            top: 10, left: 10,
            child: GestureDetector(
              onTap: () => setState(() {
                state = state - 1;
              }),
            child: Icon(Icons.arrow_back_ios, color: AppColors.matter,)),
          ) : const SizedBox(),

        ],
    );
  }

  Widget _UserCard(BuildContext context){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Container(
      width: double.infinity, height: double.infinity,
      margin: EdgeInsets.only(top: 8, right: 12, left: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        color: AppColors.primary,
      ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            RouteUtils.push(context, LoginPage());
          },
          child: ClipOval(
            child: Image.network(vm.user.upic??ConstantString.user,
                width:160,height:160,
                fit:BoxFit.cover
            ),
          ),
        ),
        SizedBox(height: 20,),
        Text("用户：${vm.user.unickname ?? "UserName"}", style: AppText.whiteHead,),
        SizedBox(height: 50,)
      ],
    )
    );
  }
  

  Widget _mapView(){
    final gm = Provider.of<GlobalModel>(context, listen: false);

    MapOptions options = MapOptions(
      initialCenter: LatLng(30.5,114.3),
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
    return Row(
      children: [
        Visibility(
          visible: state == 2,
          child: Flexible(
            flex: 3,
              child: EventPage(event: currentEvent)
          ),
        ),
        Flexible(
          flex: 5,
          child: FlutterMap(
            mapController: _mapController,
            options: options,
            children: [
              baseTileLayer(0),
              PolylineLayer(polylines: [planPolyline(recordLine)]),
              MarkerLayer(markers: recordMarker),
            ],
          ),
        ),
      ],
    );
  }


  Future<void> getRecordDetail(rid) async {
    RecordDetail recordDetail = await Api.instance.getRecordDetail(rid);
    recordLine = recordDetail.points??[];
    recordDetail.events!.forEach((event)=>
        recordMarker.add(Marker(
          width: 64, height: 64,
          point: event.point??LatLng(30, 114),
          child: GestureDetector(
            child: Image.network("http://121.41.170.185:5000/user/download/${event.id}.jpg",
              width: 64, height: 64, fit: BoxFit.cover,),
            onTap: () => setState(() {
              currentEvent = event;
              state = 2;
            })
          ),

        ))
    );
    state = 1;
    _animatedMapMove(recordLine.first, 16.5);
    setState(() {});
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