import 'package:flutter/material.dart';

class AppTheme {
  ThemeData themeData = ThemeData(
    primaryColor: Colors.brown,
    secondaryHeaderColor: Colors.blueGrey,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      // textStyle: MaterialStateProperty.all<TextStyle>(
      //     const TextStyle(color: Colors.white)
      // )
    )),
  );
}
