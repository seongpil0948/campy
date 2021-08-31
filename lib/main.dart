import 'package:campy/views/pages/common/wrong.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:campy/views/router/delegate.dart';
import 'package:campy/views/router/state.dart';

void main() {
  runApp(PyApp());
}

class PyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
                return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MaterialApp(
            home: Router(routerDelegate: PyRouterDelegate(PyState())),
          ));
        }
        else if (snapshot.hasError) {
          print("=== Flutter Initialize Error ===");
          return Wrong();
        } else {
          return CircularProgressIndicator();
        }

      },

    );
  }
}


