import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:study_project/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.blue),
    appBarTheme: const AppBarTheme(
      backgroundColor: MyConsts.BLUE,
    ),
    colorScheme: const ColorScheme.light(primary: Colors.blue),
    primaryColor: MyConsts.ORANGE,
    backgroundColor: MyConsts.OFF_WHITE,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      primary: MyConsts.BLUE,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      primary: MyConsts.BLUE,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    )),
    buttonTheme: const ButtonThemeData(buttonColor: Colors.red),
    fontFamily: 'Roboto',
  );

  static final darkTheme = ThemeData(
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
      return Colors.blue;
    })),
    inputDecorationTheme: const InputDecorationTheme(
        focusColor: MyConsts.LIGHT_BLUE, fillColor: MyConsts.LIGHT_BLUE),
    appBarTheme: const AppBarTheme(
      elevation: 5,
      backgroundColor: MyConsts.DARK_BLUE,
    ),
    colorScheme: const ColorScheme.dark(primary: Colors.blue),
    fontFamily: 'Roboto',
    primaryColor: MyConsts.LIGHT_BLUE,
    canvasColor: Colors.grey[850],
    cardColor: MyConsts.DARK_BLUE,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      primary: MyConsts.LIGHT_BLUE,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      primary: MyConsts.LIGHT_BLUE,
      onSurface: MyConsts.LIGHT_BLUE,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    )),
  );
}
