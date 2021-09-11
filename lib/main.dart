import 'package:campy/config.dart';
import 'package:campy/providers/state.dart';
import 'package:campy/views/pages/common/wrong.dart';
import 'package:campy/views/router/parser.dart';
import 'package:campy/views/utils/system_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:campy/views/router/delegate.dart';
import 'package:provider/provider.dart';

void main() {
  handleStatusBar(to: StatusBarTo.Transparent);
  runApp(PyApp());
}

class PyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider(
            create: (ctx) => PyState(),
            child: MaterialApp.router(
              title: 'Camping & Piknic',
              theme: appTheme.lightTheme,
              darkTheme: appTheme.darkTheme,
              themeMode: appTheme.currentTheme,
              routeInformationParser: PyPathParser(),
              routerDelegate: PyRouterDelegate(),
            ),
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
