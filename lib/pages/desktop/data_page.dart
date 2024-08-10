import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/widgets/map_view.dart';
import 'package:intellij_tourism_designer/models/data_model.dart';
import 'package:intellij_tourism_designer/pages/desktop/city_stats.dart';
import 'package:intellij_tourism_designer/widgets/path_query.dart';
import 'package:intellij_tourism_designer/helpers/POI_builder.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';

//信息查看模块
enum FeatureState {
  thematicMaps,
  infrestructureCheck,
  pathQuery,
  cityStats,
}

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<bool> mapLayer = List.generate(7, (index) => false);
  POI curPOI = POI();
  FeatureState curState = FeatureState.thematicMaps;

  List<Widget> featureButtonBar() {
    return [
      featureButton(FeatureState.thematicMaps, "专题地图"),
      featureButton(FeatureState.infrestructureCheck, "设施查看"),
      featureButton(FeatureState.pathQuery, "路径查询"),
      featureButton(FeatureState.cityStats, "武汉文旅"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget featureBlock = showFeatureBlock(curState, size);
    return Row(children: <Widget>[
      Container(
        height: size.height - AppSize.topBarHeight,
        width: AppSize.toolBarWidth1,
        color:AppColors.primary,
        child: Column(
          children: featureButtonBar(),
        ),
      ),
      featureBlock,
      if (curState != FeatureState.cityStats) SizedBox(
        width:size.width-AppSize.toolBarWidth1
            -((curState==FeatureState.thematicMaps)?AppSize.selectViewWidth:0)
            -((curState==FeatureState.infrestructureCheck)?AppSize.contentWidth2:0)
            -((curState==FeatureState.pathQuery)?AppSize.contentWidth3:0),
        height:size.height - AppSize.topBarHeight,
        child:const DemoMap()
      ),
    ]);
  }

  Widget featureButton(FeatureState state, String name) {
    return SizedBox(
      width: AppSize.toolBarWidth1,
      height: AppSize.buttonHeight2,
      child: TextButton(
          style: curState == state ? AppButton.button2 : AppButton.button1,
          child: Text(name),
          onPressed: () {
            setState(() {
              curState = state;
            });
          }),
    );
  }

  Widget showFeatureBlock(FeatureState curState, Size size) {
    switch (curState) {
      case FeatureState.thematicMaps:
        return SizedBox(
            height: size.height - AppSize.buttonHeight1,
            width: AppSize.selectViewWidth,
            child: Column(
              children: List.generate(7, (index) => Row(
                children: [
                  Checkbox(
                    value: mapLayer[index],
                    onChanged: (bool? newValue) {
                      setState(() {
                        mapLayer[index] = newValue ?? false;
                      });
                    }),
                  Text("Map$index", style: AppText.matter)
                ],
              ),
            )));
      case FeatureState.infrestructureCheck:
        return SizedBox(
          height: size.height - AppSize.buttonHeight1,
          width: AppSize.contentWidth2,
          child: Selector<ShareDataPage, bool>(
            selector: (BuildContext context, ShareDataPage model) =>
              model.detailed,
            builder: (BuildContext context, bool detailed, Widget? child) {
              if (!detailed) {
                return infrestructureList(context);
              }
                return Selector<ShareDataPage, POI>(
              selector: (BuildContext context, ShareDataPage model) =>
                model.curPOI,
              builder: (BuildContext context, POI curPOI, Widget? child) {
                return Stack(
                  children: [
                    POIDetailedView(poi: curPOI),
                    TextButton(
                      onPressed: () {
                        Provider.of<ShareDataPage>(context, listen: false).changeDetailed(false);
                      },
                      style: AppButton.button1,
                      child: const Icon(Icons.chevron_left),
                    )
                  ]
                );
              }
            );
          }
        )
      );
      case FeatureState.pathQuery:
        return SizedBox(
            height: size.height - 48,
            width: AppSize.contentWidth3,
            child: const PathQueryWidget());
      case FeatureState.cityStats:
        return SizedBox(
          width: size.width-AppSize.toolBarWidth1,
          height: size.height - AppSize.topBarHeight,
          child: const CityStatsPage(),
        );
      default:
        return SizedBox(
          width: size.width,
          height: size.height - AppSize.topBarHeight,
          child: const DemoMap(),
        );
    }
  }

  Widget infrestructureList(BuildContext context) {
    final model = Provider.of<ShareDataPage>(context);
    return ListView.builder(
      itemCount: model.poiList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: POICard(style: 0, poi: model.poiList[index]),
        );
      },
    );
  }
}
