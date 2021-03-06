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
    final primaryVarColor = Colors.deepPurple;
    final secondColor = Colors.grey; //1
    final origin = ThemeData.light();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      hintColor: Colors.black,
      cardColor: Colors.grey[100],
      colorScheme: ColorScheme.light().copyWith(
          secondary: secondColor,
          primary: primaryColor,
          primaryVariant: primaryVarColor),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.black),
          overline: origin.textTheme.overline!.copyWith(color: Colors.white)),
      primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
            color: primaryColor,
          ),
          bodyText2: TextStyle(color: primaryVarColor)),
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
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor, foregroundColor: Colors.white),
      buttonTheme: ButtonThemeData(
        // 4
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ButtonRadius)),
        buttonColor: primaryColor,
      ),
    );
  }

  ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
    );
  }
}
