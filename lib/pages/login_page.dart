import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/pages/register_page.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../models/global_model.dart';
import 'mobile/mobile_page.dart';

//登录界面

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _userName = "abcdefg123";
  String _passWord = "123456";

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GlobalModel>(context,listen: false);

    return Scaffold(

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _commonInput(lableText: "账号", controller: _usernameController,
                callback: (value)=>_userName=value),
              const SizedBox(height: 20,),
              _commonInput(lableText: "密码", controller: _passwordController,
                callback: (value)=>_passWord=value),
              const SizedBox(height: 50,),
              primaryInkWell(
                callback: () async {
                  bool flag = await vm.Login(name: _userName, password: _passWord);
                  if(flag){
                    RouteUtils.pop(context);
                    RouteUtils.push(context, MobilePage());//MobilePage()  DeskTopPage()
                  }else{
                    showToast("账号或密码错误");
                  }
                },
                text: "登录",
                width: 320, height: 52
              ),
              const SizedBox(height: 20,),
              transpDeepSecGesture(
                text: "注册",
                callback: () => RouteUtils.push(context, const RegisterPage()),
                width: 320, height: 52
              ),
            ],
          ),
        )
    );
  }

  Widget _commonInput(
      {required TextEditingController controller,
        required callback,
        required String lableText}){
    return TextField(
      controller: controller,
      onChanged: callback,
      style: const TextStyle(color: AppColors.deepSecondary, fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.secondary),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.deepSecondary),
          ),
          labelText: lableText,
          labelStyle: const TextStyle(color: AppColors.deepSecondary)
      ),
    );
  }
}