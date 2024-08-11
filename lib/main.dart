import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/pages/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'http/dio_instance.dart';
import 'models/global_model.dart';



void main() {
  Dio_database.instance().initDio(baseUrl: "http://121.41.170.185:5000/");
  Dio_gaode.instance().initDio(baseUrl: "https://restapi.amap.com/v3");
  Dio_enterprise.instance().initDio(baseUrl: "https://restapi.amap.com/v3");
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
