import 'package:campy/models/state.dart';
import 'package:flutter/material.dart';
import 'path.dart';

class PyPathParser extends RouteInformationParser<PyPathConfig> {
  @override
  Future<PyPathConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) return unknownPathConfig;
    final path = uri.pathSegments[0];
    switch (path) {
      case RootPath:
        return defaultPage.page;
      case FeedPath:
        if (uri.pathSegments.length == 2)
          return PyPathConfig.feedDetail(feedId: uri.pathSegments[1]);
        return feedPathConfig;
      case StorePath:
        if (uri.pathSegments.length == 2)
          return PyPathConfig.productDetail(productId: uri.pathSegments[1]);
        return storePathConfig;
      default:
        return unknownPathConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PyPathConfig configuration) {
    return RouteInformation(location: configuration.path);
  }
}
