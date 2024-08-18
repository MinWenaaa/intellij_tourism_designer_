import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/pages/login_page.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../constants/Markers.dart';
import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../helpers/tile_providers.dart';
import '../../models/plan_edit_model.dart';
import '../iti_list_page.dart';
import '../memory_list_page.dart';

/*
  个人主页
*/

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key, required this.callBack});

  final Function callBack;

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {

  int state = 0;
  List<LatLng> currentRecord = [];
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
    //final gm = Provider.of<GlobalModel>(context,listen: false);
    return Stack(
      children: [
        Row(
          children: [
            Flexible(
              flex: 5,
              child: ItiListPage(callBack: (data){
                widget.callBack.call(2);
                vm.changeEditState(true);
                vm.readPlan(data.id);
              },),
            ),
            Flexible(
              flex: 5,
              child: MemoryListPage(callBack: (data){
                currentRecord = data.getPointList();
                state = 1;
                setState((){});
              },)
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: _UserCard(context)
            ),
          ],
        ),
        state == 1 ? _mapView() : const SizedBox(),
        state == 1 ? Positioned(
          top: 10, left: 10,
          child: GestureDetector(
              onTap: () {
                state = 0;
                setState((){});
              },
              child: Icon(Icons.arrow_back_ios, color: AppColors.matter,)),
        ) : const SizedBox()
      ],
    );
  }

  Widget _UserCard(BuildContext context){
    return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            RouteUtils.push(context, LoginPage());
          },
          child: ClipOval(
            child: Image.network("https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp",
                width:180,height:180,
                fit:BoxFit.cover
            ),
          ),
        ),
        SizedBox(height: 20,),
        Text("UserName"),
        SizedBox(height: 50,)
      ],
    )
    );
  }
  

  Widget _mapView(){
    MapOptions options = MapOptions(
      initialCenter: currentRecord.first,
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
    return FlutterMap(
      mapController: _mapController,
      options: options,
      children: [
        baseTileLayer(0),
        PolylineLayer(polylines: [planPolyline(currentRecord)]),
      ],
    );
  }

}