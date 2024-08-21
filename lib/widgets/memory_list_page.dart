import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/record_list_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../http/Api.dart';
import '../models/global_model.dart';
import 'detail_view.dart';

/*
用户的出行记录列表
 */

class MemoryListView extends StatefulWidget {

  final Function callBack;
  const MemoryListView({required this.callBack, super.key});

  @override
  State<MemoryListView> createState() => _MemoryListViewState();
}

class _MemoryListViewState extends State<MemoryListView> {

  late Future<List<RecordListViewData>> recordData;
  RefreshController refreshController = RefreshController();

  Future<List<RecordListViewData>> fetch(BuildContext context) async {
    final vm = Provider.of<GlobalModel>(context,listen: false);
    List<RecordListViewData> data = await Api.instance.getRecordList(vm.user.uid??0)??[];
    return data;
  }

  @override
  void initState() {
    super.initState();
    recordData = fetch(context);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity, height: double.infinity,
      margin: EdgeInsets.only(top: 8, right: 6, left: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        color: AppColors.backGroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _Future()
      )
    );

  }


  Widget _Future(){
    return SingleChildScrollView(
      child: FutureBuilder<List<RecordListViewData>>(
          future: recordData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: List.generate(snapshot.data!.length, (index)=>GestureDetector(
                onTap: () => widget.callBack.call(snapshot.data![index]),
                child: RecordCard(data: snapshot.data![index],),
                ))
              );
            } else {
            return const SizedBox();
            }
          },

      ),
    );
  }




}
