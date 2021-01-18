import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    appBarTheme: const AppBarTheme(
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
      background: Colors.teal[100],
      onBackground: Colors.teal[300],
      error: Colors.red,
      onError: Colors.red[100],
      brightness: Brightness.light,
      surface: Colors.teal,
      onSurface: Colors.teal[100],
    ),
    cardTheme: const CardTheme(
      color: Colors.teal,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: const TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
      ),
      subtitle2: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    appBarTheme: const AppBarTheme(
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
      background: Colors.white24,
      onBackground: Colors.white,
      error: Colors.red,
      onError: Colors.red[100],
      brightness: Brightness.light,
      surface: Colors.white30,
      onSurface: Colors.white,
    ),
    cardTheme: const CardTheme(
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: const TextTheme(
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
