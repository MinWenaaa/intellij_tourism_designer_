import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/mobile/mobile_page.dart';
import 'package:provider/provider.dart';

import '../models/global_model.dart';
class MoblieApp extends StatelessWidget {
  const MoblieApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GlobalModel>(
      create: (context) => GlobalModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MobilePage(),
    ));
  }
}

