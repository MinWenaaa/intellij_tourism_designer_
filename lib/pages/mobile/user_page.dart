import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/models/global_model.dart';
import 'package:provider/provider.dart';

import '../../helpers/User.dart';
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
                SizedBox(height: 16),
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
        color: AppColors.primary,
        child: Selector<GlobalModel,User>(
          selector: (context, model) => model.user,
          builder: (BuildContext context, User user, Widget? child)=>
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 36,),
                GestureDetector(
                  onTap: onTap,
                  child: ClipOval(
                    child: Image.network(user.upic??"https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp",
                        width:80,height:80,
                        fit:BoxFit.cover
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                Text(user.unickname??"未登录", style: AppText.whiteHead),
                GestureDetector(
                    onTap: onTap,
                    child: SizedBox(height: 30)
                )

              ]
          ),
        )
    );
  }

  Widget _settingsItem(String? title, GestureTapCallback? onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity, height: 46,
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.detail, width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title??"", style: AppText.matter,),
            Icon(Icons.arrow_forward_ios, size: 26, color: AppColors.primary,)
          ],
        ),
      ),
    );
  }

}
