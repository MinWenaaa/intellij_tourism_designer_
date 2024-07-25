import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/desktop/city_stats.dart';
import 'package:intellij_tourism_designer/pages/desktop/itinenary_page.dart';
import 'package:intellij_tourism_designer/pages/desktop/map_page.dart';
import 'package:intellij_tourism_designer/pages/desktop/personal_page.dart';


class DeskTopPage extends StatefulWidget {
  @override
  _DeskTopPageState createState() => _DeskTopPageState();
}

class _DeskTopPageState extends State<DeskTopPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Intellij_tourism_designer"),
        actions:[
          Text("user"),
          ClipOval(
            child: Image.network("https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp",
                width:30,height:30,
                fit:BoxFit.cover
            ),
          ),
        ]
      ),
      body: Row(
        children: [
          NavigationRail(
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.supervised_user_circle),
                label: Text("主页")),
              NavigationRailDestination(
                  icon: Icon(Icons.map),
                  label: Text("主页")),
              NavigationRailDestination(
                  icon: Icon(Icons.fmd_good),
                  label: Text("主页")),
              NavigationRailDestination(
                  icon: Icon(Icons.add_chart),
                  label: Text("主页"))
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                PersonalPage(),
                MapPage(),
                ItineraryPage(),
                CityStatsPage(),
              ],
            ),
          )
        ]
      )
    );
  }
}