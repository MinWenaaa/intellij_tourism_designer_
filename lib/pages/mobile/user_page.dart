import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../route_utils.dart';
import '../login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
              children: [
                _header((){
                  RouteUtils.push(context, LoginPage());
                }),
                SizedBox(height: 8),
                _settingsItem("我的收藏", (){}),
                _settingsItem("检查更新", (){}),
                _settingsItem("关于我们", (){}),

              ]
          )
      ),
    );
  }

  Widget _header(GestureTapCallback? onTap){
    return Container(
        width: double.infinity,
        height: 240,
        color: Colors.teal,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              GestureDetector(
                onTap: onTap,
                child: ClipOval(
                  child: Image.network("https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp",
                      width:30,height:30,
                      fit:BoxFit.cover
                  ),
                ),
              ),
              Text("未登录", style: TextStyle(color: Colors.white,fontSize: 14)),
              GestureDetector(
                  onTap: onTap,
                  child: SizedBox(height: 30)
              )

            ]
        )
    );
  }

  Widget _settingsItem(String? title, GestureTapCallback? onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity, height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title??""),
            Icon(Icons.arrow_forward_ios, size: 26, color: Colors.black54,)
          ],
        ),
      ),
    );
  }

}
