import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/helpers/tile_providers.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:intellij_tourism_designer/pages/mobile/path_planing_page.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:provider/provider.dart';

class LayerSettingDemo extends StatefulWidget {
  const LayerSettingDemo({super.key});

  @override
  State<LayerSettingDemo> createState() => _LayerSettingDemoState();
}

class _LayerSettingDemoState extends State<LayerSettingDemo> {

  static const List<String> text= [
    "高德", "谷歌", "ArcGIS", "ArcGIS2",
  ];
  final providerEnum = BaseLayerProvider.values;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GlobalModel>(context,listen: false);

    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 24),
      child: Column(
        children: [

          Text("底图切换"),
          _baseLayerSetting(vm),
          const SizedBox(height: 20,),
          Text("显示标记"),
          _markersSetting(vm),

        ],
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
          width: 120, height: 40,
          color: provider==index ? Colors.amberAccent:Colors.lightBlueAccent,
          alignment: Alignment.center,
          child: Text(text[index]),
        ),
      )
    );
  }


  Widget _markersSetting(vm){
    return Container(
      width: double.infinity, height: 120,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [_makersButton(index: 0, model: vm),_makersButton(index: 1, model: vm)],),
          Column(
            children: [_makersButton(index: 2, model: vm),_makersButton(index: 3, model: vm)],)
        ],
      )
    );
  }

  Widget _makersButton({required int index, required GlobalModel model}){
    return Selector<GlobalModel, bool>(
      selector: (context, vm) => vm.isShowPOI[index],
      builder: (context, flag, child) => Row(
        children: [
          Checkbox(value: flag, onChanged: (value) => model.changePoiMarkerShowState(index, value!)),
          Text("CheckBox")
        ],
      ),
    );
  }

}



class ToolsSettingDemo extends StatefulWidget {
  const ToolsSettingDemo({super.key});

  @override
  State<ToolsSettingDemo> createState() => _ToolsSettingDemoState();
}

class _ToolsSettingDemoState extends State<ToolsSettingDemo> {
  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GlobalModel>(context,listen: false);

    return  Container(
        height: 200,
        color: Colors.amber,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _freePlaningButton(context: context, model: vm)
            ],
          ),
        )
    );
  }

  Widget _freePlaningButton({
    required BuildContext context, required GlobalModel model
  }){
    return InkWell(
      onTap: (){
        RouteUtils.pop(context);
        RouteUtils.push(context, PathPlanningPage());
      },
      child: Container(
        child: Text("自由规划"),
      ),
    );
  }

}



class HoverInputExample extends StatefulWidget {
  @override
  _HoverInputExampleState createState() => _HoverInputExampleState();
}

class _HoverInputExampleState extends State<HoverInputExample> {
  bool _showTextField = true;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _showTextField = true;
          _focusNode.requestFocus();
        });
      },
      onExit: (_) {
        setState(() {
          _showTextField = false;
        });
      },
      child: Stack(
        children: [
          InkWell(
              onTap: () {
                if (_textEditingController.text.isNotEmpty) {
                  // 处理输入的内容
                  print('Input: ${_textEditingController.text}');
                }
              },
              child: Container(
                width: 280, height:140,
                padding: EdgeInsets.all(16),
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text(
                  'Hover over me',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          Visibility(
            visible: _showTextField,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TextField(
                focusNode: _focusNode,
                controller: _textEditingController,
                decoration: InputDecoration(
                  labelText: 'Type here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}