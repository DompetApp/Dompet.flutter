import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Color(0xff000000),
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    ),
    scrolledUnderElevation: 0.0,
    backgroundColor: Colors.white,
    centerTitle: true,
    elevation: 0.0,
  ),
  fontFamily: 'PingFang, Arial, Sans-serif',
  primaryColorLight: Colors.white,
  primaryColor: Colors.white,
  hintColor: Colors.white,
);
