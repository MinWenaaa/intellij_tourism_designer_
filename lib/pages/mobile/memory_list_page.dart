import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/record_list_data.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../http/Api.dart';
import '../../models/global_model.dart';
import '../../widgets/detail_view.dart';

/*
用户的出行记录列表
 */

class MemoryListPage extends StatefulWidget {

  final Function changeNavigate;
  const MemoryListPage({required this.changeNavigate, super.key});

  @override
  State<MemoryListPage> createState() => _MemoryListPageState();
}

class _MemoryListPageState extends State<MemoryListPage> {

  late Future<List<RecordListViewData>> recordData;
  //late List<RecordListViewData> recordData;
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

    return Scaffold(
      body:  SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          enablePullUp: true,
          header: const ClassicHeader(),
          onRefresh: () async{
            //recordData = fetch(context);
            recordData = fetch(context);
            setState(() {});
            refreshController.refreshCompleted();

          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _Future()
        //       ListView.builder(
        //         itemCount: recordData?.length ?? 0,
        //         itemBuilder: (context, index) {
        //           return Container(
        //             height: 120,
        //             width: double.infinity,
        //             color: AppColors.primary,
        //             child: _Item(recordData![index], context),
        //     );
        //   },
        // )
    )
    ));




  }


  Widget _Future(){
    return FutureBuilder<List<RecordListViewData>>(
        future: recordData,
        builder: (context, snapshot) {
      if (snapshot.hasData) {
        return  Column(
                  children: List.generate(snapshot.data!.length, (index)=>Container(
                  height: 120,
                  width: double.infinity,
                  color: AppColors.primary,
                  child: _Item(snapshot.data![index], context),
          )),
                );
      } else {
        return const CircularProgressIndicator(color: AppColors.primary,);
      }
    },
    );
  }
  Widget _Item(RecordListViewData data, BuildContext context){
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return GestureDetector(
      onTap: () {
        vm.setCurrentRecords(data.getPointList());
        vm.changeState(mapState.view_record);
        widget.changeNavigate.call();
      },
      child: Text(data.name??""),
    );
  }

  // void Refresh(){
  //   recordData = fetch(context);
  //     refreshController.refreshCompleted();
  //     setState(() {});
  // }


}
