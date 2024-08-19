import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/pages/mobile/map_page.dart';
import 'package:intellij_tourism_designer/pages/iti_list_page.dart';
import 'package:intellij_tourism_designer/pages/memory_list_page.dart';
import 'package:intellij_tourism_designer/pages/mobile/user_page.dart';
import 'package:provider/provider.dart';
import '../../models/global_model.dart';
import 'home_page.dart';

class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {

  int currentIndex = 2;

  void onTabTapped(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GlobalModel>(context,listen: false);
    return Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedLabelStyle: TextStyle(fontSize: 12, color: AppColors.primary),
            unselectedLabelStyle: TextStyle(fontSize: 12, color: AppColors.detail),
            items: _barItemList(),
            onTap: onTabTapped
          ),
        ),
        body: SafeArea(
            child: IndexedStack(
              index: currentIndex,
              children: [
                HomePage(),
                ItiListPage(callBack: (data) {
                  vm.getPlan(id: data.id);
                  onTabTapped(2);
                }),
                MapPage(),
                MemoryListPage(callBack: (data) {
                  vm.changeRid(data.id);
                  vm.getRecordDetail();
                  vm.changeState(mapState.view_record);
                  onTabTapped(2);
                },),
                UserPage()],
            )
        )
      );
  }

  List<BottomNavigationBarItem> _barItemList(){
    return [
      _bottomBarItem(text: "首页", icons: Icons.home),
      _bottomBarItem(text: "规划", icons: Icons.alarm_on),
      _bottomBarItem(text: "地图", icons: Icons.photo),
      _bottomBarItem(text: "记录", icons: Icons.camera),
      _bottomBarItem(text: "首页", icons: Icons.person),

    ];
  }

  BottomNavigationBarItem _bottomBarItem({required String text, required IconData icons}){
    return BottomNavigationBarItem(
      icon: Icon(icons, color: AppColors.detail, size: 32,),
      activeIcon: Icon(icons, color: AppColors.primary, size: 32,),
      label: text
    );
  }

}