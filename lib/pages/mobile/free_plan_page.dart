

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/theme.dart';
import '../../models/global_model.dart';
import '../../widgets/map_view.dart';

class FreePlanPage extends StatefulWidget {
  const FreePlanPage({super.key});

  @override
  State<FreePlanPage> createState() => _FreePlanPageState();
}

class _FreePlanPageState extends State<FreePlanPage> {
  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GlobalModel>(context,listen: false);

    return Scaffold(
        body: SafeArea(
          child: Expanded(
              child: Stack(
                  children: [
                    DemoMap(),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.location_on_sharp, size: 40, color: AppColors.primary,),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          secondaryInkWell(
                              callback: () => vm.RecordCenterFlagChange(),
                              text:"添加"
                          ),
                          primaryInkWell(
                              callback: (){},
                              text: "完成"
                          )

                        ],
                      ),
                    )
                  ]
              )
          ),
        )
    );
  }

}


