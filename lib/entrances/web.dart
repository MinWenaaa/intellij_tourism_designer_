import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/desktop/desktop_page.dart';
import 'package:provider/provider.dart';
import 'package:intellij_tourism_designer/pages/desktop/personal_page.dart';
import 'package:intellij_tourism_designer/pages/login_page.dart';
import 'package:intellij_tourism_designer/pages/signup_page.dart';
import 'package:intellij_tourism_designer/pages/pickup_page.dart';
import 'package:intellij_tourism_designer/models/data_model.dart';
import 'package:intellij_tourism_designer/pages/memory_list_page.dart';
class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "智能旅游规划助手",
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
          useMaterial3: true
      ),
      home: ChangeNotifierProvider(
        create: (_) => ShareDataPage(),
        //child: const EditTracePage(),
        //child:const LoginPage()
        child: DeskTopPage(),
      ),// 网站起始界面
      routes: {
        '/login':(context) => const LoginPage(), // 登录界面
        '/signup':(context) => const SignUpPage(), // 注册界面
        '/user':(context) => const PersonalPage(), // 个人中心
        //'/main':(context) => const EditTracePage(), // 主编辑界面
        '/generate':(context) => const PickUpPage(), // 行程导出界面
      },
    );
  }
}