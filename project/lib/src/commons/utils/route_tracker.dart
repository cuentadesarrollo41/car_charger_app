import 'package:flutter/widgets.dart';

class RouteTracker extends RouteObserver<PageRoute<dynamic>> {
  String? _currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is PageRoute) {
      _currentRoute = route.settings.name;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute is PageRoute) {
      _currentRoute = previousRoute.settings.name;
    }
  }

  String? get currentRoute => _currentRoute;
}

final RouteTracker routeTracker = RouteTracker();
