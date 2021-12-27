import 'package:campy/models/state.dart';
import 'package:flutter/material.dart';
import 'path.dart';

/// 현재 루트정보를 받아, PyPathConfig 로서 파싱 및 반환한다.
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

  /// 역으로 현재 argument 데이터 타입이 어떤 루트와 매핑되는지 정의한다.
  @override
  RouteInformation restoreRouteInformation(PyPathConfig configuration) {
    return RouteInformation(location: configuration.path);
  }
}
