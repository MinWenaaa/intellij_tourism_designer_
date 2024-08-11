import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/widgets/itinerary_feature.dart';
import 'package:provider/provider.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/pages/mobile/path_planing_page.dart';
import 'package:intellij_tourism_designer/models/data_model.dart';
import 'package:intellij_tourism_designer/pages/iti_edit_page.dart';
import 'package:intellij_tourism_designer/helpers/itinerary_builder.dart';

//行程规划模块

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        flex: 2,
        child: ItiFeature(),
      ),
      /*
      Flexible(
        flex: 2,
        child: Selector<ShareDataPage, Itinerary>(
            selector: (BuildContext context, ShareDataPage model) =>
            model.curIti,
            builder: (BuildContext context, Itinerary curIti, Widget? child) {
              return ItiEditWidget(curIti: curIti);
            }
        ),
      ),*/
      Flexible(
        flex: 3,
          child: const PathPlanningPage())
    ]);
  }
}
