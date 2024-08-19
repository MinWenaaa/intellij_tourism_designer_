import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/global_model.dart';

class upLoadEvent extends StatefulWidget {
  final void Function() back;
  final LatLng point;
  final num rid;
  const upLoadEvent({super.key, required this.point, required this.rid, required this.back});

  @override
  State<upLoadEvent> createState() => _upLoadEventState();
}

class _upLoadEventState extends State<upLoadEvent> {

  File? _image;
  String _text = '';
  bool _isLoading = false;
  TextEditingController _textEditingController = TextEditingController();

  Future<void> _getImage(source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        print("uploadEvent: getImage");
        _image = File(pickedFile.path);
      });
    }
  }

  Future<num> _uploadImage() async {
    if (_image == null) return 0;

    setState(() {
      _isLoading = true;
    });

    var event_id = await Api.instance.pushEvent(point: widget.point, rid: widget.rid, image: _image!, text: _text);

    setState(() {
      _isLoading = false;
    });
    return event_id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Color(0xfff6efef),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 10),
            _EditArea(),
          ],
        )
      )
    );
  }

  AppBar _appBar(){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return AppBar(
      title: Text("旅行日记"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back), tooltip: 'Navigate back',
        onPressed: widget.back,
      ),
      actions: [ GestureDetector(
          onTap: () async {
            var id = await _uploadImage();
            vm.pushRecordMarker(marker: Marker(
              point: widget.point,
              child: Image.network("http://121.41.170.185:5000/user/download/${id}.jpg",
                width: 48, height: 48, fit: BoxFit.cover,
              )),);
            widget.back.call();
          },
          child: Container(
            alignment: Alignment.center,
            width: 66, height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: AppColors.primary
            ),
            child: Text("提交", style: TextStyle(fontSize: 16, color: Colors.white),),
          ),
        ),
        const SizedBox(width: 18,)
      ],
    );
  }

  Widget _EditArea(){
    return Container(
      width: double.infinity, height: 420,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Color(0xfffff8f7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TextField(),
            const SizedBox(height: 16,),
            _Picture(),
            const SizedBox(height: 20,),
            Text("坐标：${widget.point.longitude},${widget.point.latitude}", style: AppText.detail,)
          ],
        ),
    );
  }


  Widget _TextField(){
    return Container(
      height: 236,
      child: TextField(
        controller: _textEditingController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: "记录仅属于该点的见闻...",
          border: InputBorder.none, // 移除边框
          filled: false, // 不添加背景颜色
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) => _text=value,
      ),
    );
  }

  Widget _Picture(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
          onTap: () => _getImage(ImageSource.camera),
          child: Container(
            width: 108, height: 108,
            color: Color(0xfff2e6e6),
            child: Image.network(ConstantString.blank, width: 84, height: 84,),
          ),
      ),
    );
  }

}
