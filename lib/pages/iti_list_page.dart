import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/Constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/itinerary_builder.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:intellij_tourism_designer/pages/iti_edit_page.dart';

import '../widgets/calendar.dart';

class ItiListPage extends StatefulWidget {
  const ItiListPage({super.key});

  @override
  State<ItiListPage> createState() => _ItiListPageState();
}

class _ItiListPageState extends State<ItiListPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 18,),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Calendar(),
          ),
          const Divider(),
          const SizedBox(height: 18,),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index){
                return _Item(sampleIti);
              },
              itemCount: 10,
            ),
          )
        ]
      )
    );
  }

  Widget _Item(Itinerary iti){
    return GestureDetector(
      onTap: (){
        RouteUtils.push(context, ItiEditWidget(curIti: iti));
      },
      child: ItiCard1(curIti: iti),
    );
  }



}
