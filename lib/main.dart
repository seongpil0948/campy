import 'package:campy/views/router/delegate.dart';
import 'package:campy/views/router/state.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(PyApp());
}

class PyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MaterialApp(
          home: Router(routerDelegate: PyRouterDelegate(PyState())),
        ));
  }
}
