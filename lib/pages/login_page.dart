import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/route_utils.dart';

//登录界面

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _login(){
    RouteUtils.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.primary,
      body:Center(
        child:SizedBox(
          width:780,
          height:520,
          child:Card(
            //surfaceTintColor:AppColors.backgroundColor,
            //shadowColor:AppColors.accentColor,
            elevation:14,
            shape: const Border(),
            clipBehavior:Clip.antiAlias,
            child:Row(
              children:<Widget>[
                Container(
                  width:420,
                  height:520,
                  color:AppColors.primary,
                  child:const Center(
                    child:Column(
                      children:<Widget>[
                        SizedBox(height:200),
                        Text("Welcome Page",style:TextStyle(fontSize: 36, letterSpacing:2)),
                        Text("sign in to your accout",style:TextStyle(fontSize: 12, letterSpacing:1))
                      ]
                    )
                  )
                ),
                SizedBox(
                  width:350,
                  height:520,
                  child:Column(
                  children: <Widget>[
                    const SizedBox(height:52),
                    const SizedBox(
                      height:120,
                      child:Row(
                      children:<Widget>[
                        SizedBox(width:26),
                        Icon(Icons.map,size:90,color:AppColors.primary),
                        SizedBox(width:6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                          SizedBox(height:32),
                          Text("Hello!",style:TextStyle(fontSize:20,color:AppColors.matter)),
                          Text("Good Morning",style:TextStyle(fontSize:20,color:AppColors.primary)),
                        ]
                      )
                    ]
                  )
                ),
                    Row(
                    children:<Widget>[
                      const SizedBox(width:55),
                      SizedBox(
                        width:230,
                        child:Column(
                        children:<Widget>[
                          TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0),
                            labelText: '用户名',
                            labelStyle:AppText.matter
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0,0),
                              labelText: '密码',
                              labelStyle:AppText.matter
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor:AppColors.primary,
                                hoverColor:AppColors.primary,
                                splashRadius: 8,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                onChanged: (value) {
                                  setState(() {_rememberMe = value ?? false;});
                                },
                              ),
                              const Text('记住我',style:TextStyle(fontSize: 10,color:AppColors.matter))
                            ],
                          ),
                          const SizedBox(height: 26),
                          SizedBox(
                            height:36,
                            width:230,
                            child:ElevatedButton(
                              style:AppButton.button1,
                              onPressed: _login,
                              child: const Text('注册/登录'),
                            )
                          )
                        ]
                      )
                    )
                  ]
                )
              ],
            ),
          )
        ]
      )
    )
    )
    )
    );
  }
}