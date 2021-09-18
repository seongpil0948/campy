import 'package:campy/config.dart';
import 'package:campy/providers/auth.dart';
import 'package:campy/providers/state.dart';
import 'package:campy/views/pages/common/wrong.dart';
import 'package:campy/views/router/parser.dart';
import 'package:campy/views/utils/system_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:campy/views/router/delegate.dart';
import 'package:provider/provider.dart';

const USE_FIRESTORE_EMULATOR = false;

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
          if (USE_FIRESTORE_EMULATOR) {
            FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => PyState(),
              ),
              ChangeNotifierProvider(create: (ctx) => PyAuth())
            ],
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
