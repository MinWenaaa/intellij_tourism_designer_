import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/mobile/map_page.dart';
import 'package:intellij_tourism_designer/pages/iti_list_page.dart';
import 'package:intellij_tourism_designer/pages/memory_list_page.dart';
import 'package:intellij_tourism_designer/pages/mobile/user_page.dart';
import 'package:intellij_tourism_designer/widgets/searching_bar.dart';
import 'home_page.dart';

class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {

  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedLabelStyle: TextStyle(fontSize: 14, color: Colors.black),
            unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.teal),
            items: _barItemList(),
            onTap: (index){
              currentIndex = index;
              setState(() {});
            },
          ),
        ),
        body: SafeArea(
            child: IndexedStack(
              index: currentIndex,
              children: [HomePage(), ItiListPage(), MapPage(), MemoryListPage(), UserPage()],
            )
        )
    );
  }

  List<BottomNavigationBarItem> _barItemList(){
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, color: Colors.black38, size: 32),
          activeIcon: Icon(Icons.home_filled, color: Colors.greenAccent, size: 32),
          label: "首页"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.medication, color: Colors.black38, size: 32),
          activeIcon: Icon(Icons.medication, color: Colors.greenAccent, size: 32),
          label: "规划"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.photo, color: Colors.black38, size: 32),
          activeIcon: Icon(Icons.photo, color: Colors.greenAccent, size: 32),
          label: "地图"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle, color: Colors.black38, size: 32),
          activeIcon: Icon(Icons.supervised_user_circle, color: Colors.greenAccent, size: 32),
          label: "记录"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle, color: Colors.black38, size: 32),
          activeIcon: Icon(Icons.supervised_user_circle, color: Colors.greenAccent, size: 32),
          label: "我的"
      )
    ];
  }

}