import 'package:flutter/material.dart';

final buttonRadius = 18.0;

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
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
      ),
      // visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
      accentColor: primaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius)),
        ),
      ),
      buttonTheme: ButtonThemeData(
        // 4
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
        buttonColor: primaryColor,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.greenAccent,
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme,
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.deepPurple,
        ));
  }
}
