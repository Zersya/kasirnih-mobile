import 'package:flutter/material.dart';
import 'package:ks_bike_mobile/main.dart';
import 'package:ks_bike_mobile/modules/auth/auth_screen.dart';
import 'package:ks_bike_mobile/modules/splashscreen/splash_screen.dart';

class RouterHelper {
  

  static const String kRouteAuth = '/login';
  static const String kRouteHome = '/home';
  static const String kRouteSplashScreen = '/splashScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kRouteAuth:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case kRouteHome:
        return MaterialPageRoute(
          builder: (_) => MyHomePage(
            title: 'Demo Home',
          ),
        );
      case kRouteSplashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      default:
        return MaterialPageRoute(builder: (_) => AuthScreen());
    }
  }
}
