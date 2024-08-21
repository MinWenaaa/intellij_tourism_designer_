import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/desktop_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../models/global_model.dart';
import '../route_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _userName = "";
  String _passWord = "";

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
                    bool flag = await vm.Signup(name: _userName, password: _passWord);
                    if(flag){
                      RouteUtils.pop(context);
                      RouteUtils.pop(context);
                      RouteUtils.push(context, DeskTopPage());
                    } else {
                      showToast("用户已注册");
                    }
                  },
                  text: "注册",
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
