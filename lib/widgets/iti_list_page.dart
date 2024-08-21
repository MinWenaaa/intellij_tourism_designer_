import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/widgets/calendar.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../helpers/Iti_data.dart';
import '../http/Api.dart';
import '../models/global_model.dart';

class ItiListView extends StatefulWidget {

  final Function callBack;
  const ItiListView({required this.callBack, super.key});

  @override
  State<ItiListView> createState() => _ItiListViewState();

}

class _ItiListViewState extends State<ItiListView> {

  late Future<List<PlanListViewData>> planData;
  RefreshController refreshController = RefreshController();

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

    return Container(
      width: double.infinity, height: double.infinity,
      margin: EdgeInsets.only(top: 8, right: 6, left: 12),
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
      child: Column(
        children: [
          Calendar(),
          FutureBuilder<List<PlanListViewData>>(
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
        ],
      ),
    );
  }



}
