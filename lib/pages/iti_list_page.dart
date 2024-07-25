import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/Constants.dart';
import 'package:intellij_tourism_designer/helpers/itinerary_builder.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:intellij_tourism_designer/pages/iti_edit_page.dart';

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
          Container(
            height: 240, width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
          ),
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
