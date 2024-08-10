import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:intellij_tourism_designer/pages/desktop/desktop_page.dart';
import 'package:intellij_tourism_designer/pages/mobile/mobile_page.dart';
import 'package:intellij_tourism_designer/pages/register_page.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../models/global_model.dart';

//登录界面

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _userName = "";
  String _passWord = "";

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GlobalModel>(context,listen: false);

    return Scaffold(
        backgroundColor: Colors.teal,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _commonInput(lableText: "账号", controller: _usernameController,
                callback: (value)=>_userName=value),
              SizedBox(height: 20,),
              _commonInput(lableText: "密码", controller: _passwordController,
                callback: (value)=>_passWord=value),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: () async {
                  await vm.Login(name: _userName, password: _passWord).then((value){
                    if(value){
                      RouteUtils.push(context, MobilePage());
                    }else{
                    showToast("账号或密码错误");
                    }
                  });
                },
                child: Container(
                  width: double.infinity, height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(22.5))
                  ),
                  child: Text("登录", style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  RouteUtils.push(context, RegisterPage());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100, height: 45,
                  child: Text("注册", style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20,),
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
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0.5)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1)
          ),
          labelText: lableText,
          labelStyle: TextStyle(color: Colors.white)
      ),
    );
  }
}