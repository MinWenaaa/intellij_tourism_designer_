import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/tile_providers.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:provider/provider.dart';

class LayerSettingDemo extends StatefulWidget {
  const LayerSettingDemo({super.key,});

  @override
  State<LayerSettingDemo> createState() => _LayerSettingDemoState();
}

class _LayerSettingDemoState extends State<LayerSettingDemo> {

  static const List<String> text= [
    "高德", "谷歌", "ArcGIS", "ArcGIS2",
  ];
  final providerEnum = BaseLayerProvider.values;
  bool? _showSelect = false;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GlobalModel>(context,listen: false);

    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 48),
        child: ListView(
            children: [

              const SizedBox(height: 40,),
              _baseLayerSetting(vm),
              const SizedBox(height: 40,),
              _markersSetting(vm),
              const SizedBox(height: 40,),
              _sunsetButton(),
              const SizedBox(height: 40,),
              _HeatMapButtons(),
              const SizedBox(height: 40,),
              _FeatureButtons(),

            ],
        ),
      ),
    );
  }

  AppBar _appBar(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return AppBar(
      title: const Text("图层设置"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back), tooltip: 'Navigate back',
        onPressed: () => vm.changeSetting(false),
      ),
    );
  }

  Widget _baseLayerSetting(vm){
    return Container(
        width: double.infinity, height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index)=>GestureDetector(
            child: _baseLayerButton(index: index,model: vm),
          ),
          scrollDirection: Axis.horizontal,

        ),
    );
  }

  Widget _baseLayerButton({required int index, required GlobalModel model}){
    return Selector<GlobalModel, int>(
      selector: (context, vm)=>vm.baseProvider,
      builder: (context, provider, child)=>InkWell(
        onTap: () => model.changeBaseLayer(index),
        child: Container(
          width: 108, height: 40,
          color: provider==index ? AppColors.primary : null,
          alignment: Alignment.center,
          child: Text(text[index]),
        ),
      )
    );
  }


  Widget _markersSetting(vm){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("地图图钉"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_makersButton(index: 0, model: vm),_makersButton(index: 1, model: vm)],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_makersButton(index: 2, model: vm),_makersButton(index: 3, model: vm)],)
        ],
      )
    );
  }

  Widget _makersButton({required int index, required GlobalModel model}){
    return Selector<GlobalModel, bool>(
      selector: (context, vm) => vm.showPOI[index],
      builder: (context, flag, child) => Row(
        children: [
          Checkbox(value: flag, onChanged: (value) => model.changePoiLayer(index, value!)),
          Text(ConstantString.poi[index])
        ],
      ),
    );
  }

  Widget _sunsetButton(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Selector<GlobalModel, int>(
        selector: (context, vm) => vm.showSunset,
        builder: (context, v, child) => Row(
          children: [
            Text("落日质量预告"),
            Checkbox(
              value: _showSelect,
              onChanged: (value) {setState(() {
                _showSelect = value;
                if(!value!){
                  vm.changeSunset(-1);
                }
              });}
            ),
            Expanded(child: const SizedBox()),
            Visibility(
              maintainSize: true, maintainAnimation: true, maintainState: true,
              visible: _showSelect??false,
              child: DropdownMenu<int>(
                menuHeight: 200,
                dropdownMenuEntries: _buildSunsetList(),
                onSelected: (value) => vm.changeSunset(value??0),
              ),
            )
          ],
        )
    );
  }

  List<DropdownMenuEntry<int>> _buildSunsetList() {
    return List.generate(12,
      (index) =>DropdownMenuEntry<int>(
          value: index, label: ConstantString.month[index],
        labelWidget: Text(ConstantString.month[index])
      )
    );
  }


  Widget _HeatMapButtons(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Column(
      children: [
        Text("热力图"),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [_HeatMapButton(index: 0, model: vm),_HeatMapButton(index: 1, model: vm)],),
              Column(
                children: [_HeatMapButton(index: 2, model: vm),_HeatMapButton(index: 3, model: vm)],)
            ],
          )
        )
      ],
    );
  }

  Widget _HeatMapButton({required int index, required model}){
    return Selector<GlobalModel, bool>(
      selector: (context, vm) => vm.showHeatMap[index],
      builder: (context, flag, child) => Row(
        children: [
          Checkbox(value: flag, onChanged: (value) => model.changeHeatMap(index, value!)),
          Text(ConstantString.poi[index])
        ],
      ),
    );
  }


  Widget _FeatureButtons(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Column(
      children: [
        Text("属性分布"),
        Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) =>
                  _FeatureButton(index: index, model: vm)
              )
            )
        )
      ],
    );
  }

  Widget _FeatureButton({required int index, required model}){
    return Selector<GlobalModel, bool>(
      selector: (context, vm) => vm.showFeatureMap[index],
      builder: (context, flag, child) => Row(
        children: [
          Checkbox(value: flag, onChanged: (value) => model.changeFeature(index, value!)),
          Text(ConstantString.featureLayer[index])
        ],
      ),
    );
  }

}
