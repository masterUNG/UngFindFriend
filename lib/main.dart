import 'package:flutter/material.dart';
import 'package:ungfindfriend/states/authen.dart';
import 'package:ungfindfriend/states/create_account.dart';
import 'package:ungfindfriend/states/my_service.dart';
import 'package:ungfindfriend/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myService': (BuildContext context) => MyService(),
};

String? initialRoute;

void main() {
  initialRoute = MyConstant.routeMyService;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
