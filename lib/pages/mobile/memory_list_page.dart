import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/record_list_data.dart';
import 'package:provider/provider.dart';
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
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<RecordListViewData>>(
          future: recordData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index){
                  return Container(
                    height: 120, width: double.infinity,
                    color: AppColors.primary,
                    child: _Item(snapshot.data?[index]??RecordListViewData(), context),
                  );
                },
                itemCount: snapshot.data?.length??0,
              );
            } else {
              return const CircularProgressIndicator(color: AppColors.primary,);
            }
          },
        ),
      )

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
}
