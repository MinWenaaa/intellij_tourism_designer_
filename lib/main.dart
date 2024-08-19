import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intellij_tourism_designer/pages/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'http/dio_instance.dart';
import 'models/global_model.dart';



void main() {
  Dio_database.instance().initDio();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<GlobalModel>(
        create: (context) => GlobalModel(),
        child: OKToast(
          child: ScreenUtilInit(
            designSize: const Size(1080, 2400),
            builder: (context, child) => MaterialApp(
              title: 'intellij_tourism_desigenr',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffff7287)),
                useMaterial3: true,
              ),
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              home: const LoginPage(),
            ),
          ),
    ));
  }
}
