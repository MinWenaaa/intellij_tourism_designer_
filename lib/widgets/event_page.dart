import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:provider/provider.dart';

import '../models/global_model.dart';

class EventPage extends StatelessWidget {

  final event;
  const EventPage({super.key, this.event});

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
                width: double.infinity, height: 720.h, fit: BoxFit.cover,),
                SizedBox(height: 48.h,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
                  height: 480.h, alignment: Alignment.topLeft,
                  color: AppColors.highlight,
                  child: Text(event.text, style: AppText.Head2,)
                )
              ],
            )
        )
    );
  }

  AppBar _appBar(BuildContext context){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return AppBar(
      title: Text("旅行日记"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back), tooltip: 'Navigate back',
        onPressed: () => vm.changeState(mapState.view_record),
      )
    );
  }
}

