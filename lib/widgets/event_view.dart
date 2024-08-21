import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:provider/provider.dart';

import '../models/global_model.dart';

class EventPage extends StatelessWidget {

  final event;
  const EventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        backgroundColor: Color(0xfff6efef),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.network("http://121.41.170.185:5000/user/download/${event.id}.jpg",
                  width: double.infinity, height: 360, fit: BoxFit.cover,),
                SizedBox(height: 24,),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    height: 320, alignment: Alignment.topLeft,
                    color: AppColors.highlight,
                    child: Text(event.text, style: AppText.Head2,)
                )
              ],
            )
        )
    );
  }

  AppBar _appBar(BuildContext context){
    return AppBar(
        title: Text("旅行日记"),
      leading: const SizedBox(),
    );
  }
}