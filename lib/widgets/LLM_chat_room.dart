import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/helpers/Iti_data.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:latlong2/latlong.dart';

import '../constants/theme.dart';
import '../http/Api.dart';

class LLMChatRoom extends StatefulWidget {

  final Function() back;
  final Function(LatLng, double) move;

  const LLMChatRoom({super.key, required this.move, required this.back});

  @override
  State<LLMChatRoom> createState() => _LLMChatRoomState();
}

class _LLMChatRoomState extends State<LLMChatRoom> {

  final TextEditingController _textController = TextEditingController();
  String requirement = "";

  List<Widget> messags = [
    Text("你是谁？"),
    Text("我是正在开发中的旅游助手，我可以向您推荐指定风格的旅游景点，有什么我可以帮助您的吗")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Column(
          children: [
            _messageList(),
            Column(
                children: [
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TextField(),
                      _confirmButton()
                    ],
                  ),
                  const SizedBox(height: 12,)
                ],
              ),

          ],
        ),
      ),
    );
  }


  AppBar _appBar(){
    return AppBar(
      title: Text("智能景点推荐"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: widget.back,
        tooltip: 'Navigate back',
      ),
    );
  }

  Widget _messageList(){
    return Expanded(
      child: ListView(
        children: List.generate(messags.length, (index)=> index%2==0 ? _HumanMessage(messags[index]) : _RobotMessage(messags[index])),
        shrinkWrap: true,
      ),
    );
  }

  Widget _TextField(){
    return SizedBox(
      width: 420,
      child: TextField(
        controller: _textController,
        onChanged: (value) {
          requirement = value;
        },
        style: const TextStyle(color: AppColors.deepSecondary, fontSize: 14),
        decoration: InputDecoration(
          fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.deepSecondary),
            ),
            icon: Image.network(ConstantString.robot, width: 36, height: 36,),
            hintText: "输入对景点的期待，大模型为您智能推荐",
            labelStyle: const TextStyle(color: AppColors.deepSecondary)
        ),
      ),
    );
  }

  Widget _confirmButton(){
    return InkWell(
      onTap: (){
        messags.add(Text(requirement));
        messags.add(RobotMessage(requirement: requirement, move: widget.move,));
        _textController.clear();
        setState((){});
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        padding: EdgeInsets.only(left:10, right: 8, top: 8, bottom: 10),
        child: Image.network(ConstantString.send, width: 32, height: 32,)
      ),
    );
  }

  Widget _HumanMessage(Widget child){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: SizedBox()),
        ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: 400
            ),
            child: Container(
              margin: EdgeInsets.only(top: 12, right: 8, bottom: 12),
              padding: EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(0.0),
                  topLeft: Radius.circular(16)
                ),
                color: AppColors.primary,
              ),
              child: child,
            ),
        ),
        ClipOval(
          child: Image.network(ConstantString.user,
              width:44,height:44,
              fit:BoxFit.cover
          ),
        ),
        const SizedBox(width: 16,)
      ],
    );
  }


  Widget _RobotMessage(Widget child){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 16,),
        ClipOval(
          child: Image.network(ConstantString.robot,
              width:44,height:44,
              fit:BoxFit.cover
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: 400,
          ),
          child: Container(
            margin: EdgeInsets.only(top: 12, left: 8, bottom: 12),
            padding: EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(12),
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(0)),
              color: Colors.white,
            ),
            child: child,
          ),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }

}


class RobotMessage extends StatefulWidget {

  final Function(LatLng, double) move;
  final String requirement;
  const RobotMessage({super.key, required this.requirement, required this.move});

  @override
  State<RobotMessage> createState() => _RobotMessageState();
}

class _RobotMessageState extends State<RobotMessage> {

  late Future<List<ItiData>> listData;

  Future<List<ItiData>> fetch() async {
    List<ItiData> data = await Api.instance.getChatLLM(requirement: widget.requirement)??[];
    return data;
  }

  @override
  void initState() {
    super.initState();
    listData = fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("根据您的要求，推荐以下景点："),
        FutureBuilder<List<ItiData>>(
          future: listData,
          builder: (context, snapshot) => snapshot.hasData ? Column(
            children: List.generate(snapshot.data!.length, (index) => GestureDetector(
              onTap: () => widget.move.call(LatLng(snapshot.data![index].y??30, snapshot.data![index].x??114), 16.5),
              child: ActCard(itiData: snapshot.data![index],),
            ))
          ) : Center(
            child: SizedBox(
              width: 36, height: 36,
              child: const CircularProgressIndicator(color: AppColors.primary,)
            )
          )
        )
      ],
    );
  }
}
