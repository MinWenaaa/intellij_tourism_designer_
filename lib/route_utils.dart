import 'package:flutter/material.dart';

class RouteUtils{
  RouteUtils._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;

  //页面跳转
  static Future push(
      BuildContext context,
      Widget page,{
      bool? fullcsreenDiaglog,
      RouteSettings? settings,
      bool maintainState = true,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
        fullscreenDialog: fullcsreenDiaglog ?? false,
        settings: settings,
        maintainState: maintainState,
      )
    );
  }

  //路径跳转
  static Future pushForNamed(
      BuildContext context,
      String name, {
      Object? argument,
  }){
    return Navigator.pushNamed(context, name, arguments: argument);
  }

  //route跳转
  static Future pushForPageRoute(BuildContext context, Route route){
    return Navigator.push(context, route);
  }

  //清空栈、保留目标页面
  static Future pushNamedAndRemoveUntil(
      BuildContext context,
      String name,{
      Object? arguments,
  }){
    return Navigator.pushNamedAndRemoveUntil(context, name, (route)=>false, arguments: arguments);
  }

  //清空栈、保留目标页面
  static Future pushAndRemoveUntil(
      BuildContext context,
      Widget page,{
      bool? fullscreenDialog,
      RouteSettings? settings,
      bool maintainState = true,
  }) {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => page,
          fullscreenDialog: fullscreenDialog ?? false,
          settings: settings,
          maintainState: maintainState,
        ),
            (route) => false
    );
  }

  //新路由替换当前路由
  static Future pushReplacement(BuildContext context, Route route, {Object? result}){
    return Navigator.pushReplacement(context, route, result: result);
  }

  //新路由替换当前路由
  static Future pushReplacementNamed(
      BuildContext context,
      String name,{
        Object? result,
        Object? arguments,
  }){
    return Navigator.pushReplacementNamed(context, name, arguments: arguments, result: result);
  }

  //关闭当前页面
  static void pop(BuildContext context){
    Navigator.pop(context);
  }

  //关闭当前页面：包含返回值
  static void popofData<T extends Object?>(BuildContext context, {T? data}){
    Navigator.of(context).pop(data);
  }

}