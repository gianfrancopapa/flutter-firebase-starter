import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    appBarTheme: AppBarTheme(
      color: Colors.teal,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme(
      primary: Colors.white,
      primaryVariant: Colors.white38,
      onPrimary: Colors.white,
      secondary: Colors.red,
      secondaryVariant: Colors.red[50],
      onSecondary: Colors.red,
      background: null,
      onBackground: null,
      error: null,
      onError: null,
      brightness: null,
      surface: null,
      onSurface: null,
    ),
    cardTheme: CardTheme(
      color: Colors.teal,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      primaryVariant: Colors.black,
      onPrimary: Colors.black,
      secondary: Colors.red,
      secondaryVariant: Colors.red[50],
      onSecondary: Colors.red,
      background: null,
      onBackground: null,
      error: null,
      onError: null,
      brightness: null,
      surface: null,
      onSurface: null,
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ),
  );
}
