import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum StatusBarTo {
  Transparent,
  Restore,
  Disable,
  Ignore
}

void handleStatusBar({StatusBarTo to=StatusBarTo.Ignore}) {
  switch (to) {
    case StatusBarTo.Disable: 
      SystemChrome.setEnabledSystemUIOverlays([]);
      break;
    case StatusBarTo.Transparent: 
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ));
      break;
    case StatusBarTo.Restore: 
      SystemChrome.restoreSystemUIOverlays();
      break;
    case StatusBarTo.Ignore:
      break;
  }
}