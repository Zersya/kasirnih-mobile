import 'package:flutter/material.dart';
import 'package:ks_bike_mobile/modules/auth/auth_screen.dart';
import 'package:ks_bike_mobile/modules/home/home_screen.dart';
import 'package:ks_bike_mobile/modules/splashscreen/splash_screen.dart';
import 'package:ks_bike_mobile/modules/store_form/store_form_screen.dart';

class RouterHelper {
  static const String kRouteAuth = '/login';
  static const String kRouteHome = '/home';
  static const String kRouteStoreFormState = '/store_register';
  static const String kRouteSplashScreen = '/splashScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kRouteAuth:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case kRouteHome:
        return MaterialPageRoute(builder: (_) => HomeScreen(settings.arguments));
      case kRouteSplashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case kRouteStoreFormState:
        return MaterialPageRoute(builder: (_) => StoreFormStateScreen());
      default:
        return MaterialPageRoute(builder: (_) => AuthScreen());
    }
  }
}
