import 'package:campy/views/pages/common/wrong.dart';
import 'package:campy/views/router/parser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:campy/views/router/delegate.dart';
import 'package:campy/views/router/state.dart';

void main() {
  runApp(PyApp());
}

class PyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    final primaryColor = Colors.blue.shade900;

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp.router(
            title: 'Camping & Piknic',
            theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: primaryColor,
                ),
                // buttonTheme: ButtonThemeData(buttonColor: primaryColor),
                // brightness: Brightness.light,
                // visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
                // primaryColorLight: Colors.blue.shade900,
                accentColor: primaryColor),
            routeInformationParser: PyPathParser(),
            routerDelegate: PyRouterDelegate(PyState()),
          );
        } else if (snapshot.hasError) {
          print("=== Flutter Initialize Error ===");
          return WrongView(key: ValueKey("Wrong"));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
