import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/memory_view_page.dart';
import '../constants/Constants.dart';
import '../helpers/itinerary_builder.dart';
import '../route_utils.dart';
import '../widgets/detail_view.dart';
import 'iti_edit_page.dart';

/*
用户的出行记录列表
 */

class MemoryListPage extends StatefulWidget {
  const MemoryListPage({super.key});

  @override
  State<MemoryListPage> createState() => _MemoryListPageState();
}

class _MemoryListPageState extends State<MemoryListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: ListView.builder(
          itemBuilder: (context, index){
            return _Item(sampleIti);
          },
          itemCount: 10,
        ),
      ),
    );
  }

  Widget _Item(Itinerary iti){
    return GestureDetector(
      onTap: (){
        RouteUtils.push(context, MemoryView());
      },
      child: ItiCard1(curIti: iti),
    );
  }
}
