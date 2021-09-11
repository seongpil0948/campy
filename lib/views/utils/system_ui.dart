import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum StatusBarTo { Transparent, Restore, Ignore }

void handleStatusBar({StatusBarTo to = StatusBarTo.Ignore}) {
  switch (to) {
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
