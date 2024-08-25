import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/state_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

//城市旅游信息页面

class CityStatsPage extends StatefulWidget {
  const CityStatsPage({super.key});

  @override
  State<CityStatsPage> createState() => _CityStatsPageState();
}

class _CityStatsPageState extends State<CityStatsPage> {


  final LayerHitNotifier<int> _hitNotifier = ValueNotifier(null);
  List<int>? _prevHitValues;
  List<Polygon<int>>? _hoverGons;
  int currentDistrict = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                            margin:  const EdgeInsets.only(left: 36, right: 18, top:16, bottom:16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                              color: AppColors.highlight
                            ),
                            padding: EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                currentDistrict!=-1 ? Text(ConstantString.district[currentDistrict], style: AppText.matter): SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(currentDistrict==-1?ConstantString.chart[1]:ConstantString.pie[currentDistrict%7]),
                                ),
                              ],
                            ),
                          ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: _wuhanView(),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(ConstantString.chart[2]),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: AppColors.highlight
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(ConstantString.chart[0]),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(ConstantString.word[currentDistrict%10]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  MapOptions _options(){
    return  MapOptions(
      backgroundColor: AppColors.highlight,
      initialCenter: const LatLng(30.6,114.4),
      initialZoom: 8.3,
      maxZoom: 8.3,
      minZoom: 8.3,
      cameraConstraint: CameraConstraint.contain(
        bounds: LatLngBounds(
          const LatLng(29.9, 113.7),
          const LatLng(31.3, 115),
        ),
      ),
    );
  }

  Widget _wuhanView() {
    final vm = Provider.of<StateModel>(context,listen: false);
    vm.init();
    return Container(
      width: 440, height: 480,
      child: FlutterMap(
        options: _options(),
        children: [
          Selector<StateModel, List<Polygon<int>>>(
            selector: (context, provider) => provider.listPolygon,
            builder: (context, data, child) {
              return MouseRegion(
                  hitTestBehavior: HitTestBehavior.deferToChild,
                  cursor: SystemMouseCursors.click,
                  onHover: (_) {
                    final hitValues = _hitNotifier.value?.hitValues.toList();
                    if (hitValues == null) return;

                    if (listEquals(hitValues, _prevHitValues)) return;
                    _prevHitValues = hitValues;

                    final hoverLines = hitValues.map((v) {
                      final original = data[v];

                      return Polygon<int>(
                        points: original.points,
                        holePointsList: original.holePointsList,
                        color: Colors.transparent,
                        borderStrokeWidth: 4,
                        borderColor: AppColors.deepSecondary,
                        disableHolesBorder: original.disableHolesBorder,
                      );
                    }).toList();
                    setState(() => _hoverGons = hoverLines);
                  },
                  onExit: (_) {
                    _prevHitValues = null;
                    setState(() => _hoverGons = null);
                  },
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        currentDistrict  = _hitNotifier.value!.hitValues[0];
                      });
                    },
                    child: PolygonLayer(
                      hitNotifier: _hitNotifier,
                      simplificationTolerance: 0,
                      polygons: [
                        ...data, ...?_hoverGons],
                    )
                  )
              );
            }
          ),
        ],
      ),
    );
  }
}
