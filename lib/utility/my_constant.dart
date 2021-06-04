import 'package:flutter/material.dart';

class MyConstant {
  // Route
  static String routeAuthen = '/authen';
  static String routeCrateAccount = '/createAccount';
  static String routeMyService = '/myService';

  // General
  static String appName = 'Ung Find Friend';

  // API
  static String apiReadAllUser = 'https://www.androidthai.in.th/bigc/getAllUser.php';

  // Image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';

  // Color
  static Color primary = Color(0xff7b1fa2);
  static Color dart = Color(0xff4a0072);
  static Color light = Color(0xffae52d4);

  // Style
  TextStyle h1Style() => TextStyle(
    color: dart,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  TextStyle h2Style() => TextStyle(
    color: dart,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  TextStyle h3Style() => TextStyle(
    color: dart,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
}
