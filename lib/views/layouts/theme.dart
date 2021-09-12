import 'package:flutter/material.dart';

const ButtonRadius = 18.0;
const OvalRadius = 40.0;
const OvalBorderWidth = 3.0;

abstract class PyThemeInterface with ChangeNotifier {
  ThemeData get lightTheme;
  ThemeData get darkTheme;

  static bool _isDarkTheme = false; // default Theme is Light
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}

class PyTheme extends PyThemeInterface {
  ThemeData get lightTheme {
    final primaryColor = Colors.blue.shade900; //1
    final origin = ThemeData.light();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      cardColor: Colors.grey[100],
      colorScheme: ColorScheme.light().copyWith(secondary: Colors.grey),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.white),
          overline: origin.textTheme.overline!.copyWith(color: Colors.white)),
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          toolbarTextStyle: TextStyle(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0),
      // visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ButtonRadius)),
        ),
      ),
      dividerColor: Colors.black,
      iconTheme: IconThemeData(color: primaryColor),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: ThemeData.light().textTheme.caption,
        border: OutlineInputBorder(
            borderSide: BorderSide(width: OvalBorderWidth, color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(OvalRadius))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OvalRadius),
          borderSide: BorderSide(width: OvalBorderWidth, color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OvalRadius),
          borderSide: BorderSide(width: OvalBorderWidth, color: primaryColor),
        ),
      ),
      buttonTheme: ButtonThemeData(
        // 4
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ButtonRadius)),
        buttonColor: primaryColor,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.greenAccent,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme,
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.deepPurple,
        ));
  }
}
