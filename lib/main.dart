import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'http/dio_instance.dart';
import 'models/global_model.dart';



void main() {
  Dio_database.instance().initDio(baseUrl: "http://121.41.170.185:5000/");
  Dio_gaode.instance().initDio(baseUrl: "http://182.92.251.24:5000/");
  Dio_enterprise.instance().initDio(baseUrl: "http://182.92.251.24:8080/");
  Dio_qw.instance().initDio(baseUrl: "https://devapi.qweather.com/v7/");
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<GlobalModel>(
        create: (context) => GlobalModel(),
        child: OKToast(
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfffffbfb)),
              useMaterial3: true,
            ),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: const LoginPage(),
              ),
        ));
  }
}
