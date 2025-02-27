import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellij_tourism_designer/widgets/calendar.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../helpers/Iti_data.dart';
import '../http/Api.dart';
import '../models/global_model.dart';

class ItiListPage extends StatefulWidget {

  final Function callBack;
  const ItiListPage({required this.callBack, super.key});

  @override
  State<ItiListPage> createState() => _ItiListPageState();

}

class _ItiListPageState extends State<ItiListPage> {

  late Future<List<PlanListViewData>> planData;
  final RefreshController refreshController = RefreshController();

  Future<List<PlanListViewData>> fetch(BuildContext context) async {
    final vm = Provider.of<GlobalModel>(context,listen: false);
    List<PlanListViewData> data = await Api.instance.getPlanList(vm.user.uid??0)??[];
    return data;
  }

  @override
  void initState() {
    super.initState();
    planData = fetch(context);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Calendar(),
        Container(
          height: 720.h,
          child: SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: const ClassicHeader(),
            onRefresh: () async{
              planData = fetch(context);
              setState(() {});
              refreshController.refreshCompleted();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 22.h),
              child: _Future()
            )
          ),
        )
      ],
    );
  }


  Widget _Future(){
    return SingleChildScrollView(
      child: FutureBuilder<List<PlanListViewData>>(
              future: planData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: List.generate(snapshot.data!.length, (index)=>GestureDetector(
                      onTap: () => widget.callBack.call(snapshot.data![index]),
                      child: ItiCard(data: snapshot.data![index],),
                    )),
                  );
                } else {
                  return const SizedBox();
                }
              },

      ),
    );
  }



}
