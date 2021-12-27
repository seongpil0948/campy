import 'package:campy/components/inputs/text_controller.dart';
import 'package:campy/config.dart';
import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/models/state.dart';
import 'package:campy/repositories/push/fcm.dart';
import 'package:campy/views/pages/common/wrong.dart';
import 'package:campy/views/router/parser.dart';
import 'package:campy/utils/system_ui.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:campy/views/router/delegate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
          final crasher = FirebaseCrashlytics.instance;
          FlutterError.onError = crasher.recordFlutterError;
          FirebaseAnalytics.instance.logAppOpen();
          fcmInitialize();
          crasher.log(
              "Crahser is Initialiazed ${crasher.isCrashlyticsCollectionEnabled}");
          // crasher.recordError(null, null,
          //     reason: 'APP OPEN Error', fatal: true);
          // crasher.crash();
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (ctx) => PyState(),
              ),
              ChangeNotifierProvider(create: (ctx) => PyAuth()),
              ChangeNotifierProvider(create: (ctx) => FeedSearchVal())
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
