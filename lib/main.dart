import 'package:campy/config.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/models/state.dart';
import 'package:campy/repositories/push/fcm.dart';
import 'package:campy/views/pages/common/wrong.dart';
import 'package:campy/views/router/parser.dart';
import 'package:campy/utils/system_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:campy/views/router/delegate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const USE_FIRESTORE_EMULATOR = false;

void main() {
  handleStatusBar(to: StatusBarTo.Transparent);
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(PyApp());
}

class PyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          FirebaseCrashlytics.instance.log("Init Crashlytics");
          fcmInitialize();
          final app = snapshot.data as FirebaseApp;
          print("APP Initialized: ${app.toString()}");

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
          return WrongView(key: ValueKey("Wrong"));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
