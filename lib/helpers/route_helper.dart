import 'package:flutter/material.dart';
import 'package:ks_bike_mobile/modules/auth/auth_screen.dart';
import 'package:ks_bike_mobile/modules/home/home_screen.dart';
import 'package:ks_bike_mobile/modules/invoice_debt/invoice_debt_form_screen.dart';
import 'package:ks_bike_mobile/modules/invoice_debt/invoice_debt_screen.dart';
import 'package:ks_bike_mobile/modules/new_item_facilities/new_item_facilities_screen.dart';
import 'package:ks_bike_mobile/modules/splashscreen/splash_screen.dart';
import 'package:ks_bike_mobile/modules/store_form/store_form_screen.dart';

class RouterHelper {
  static const String kRouteAuth = '/login';
  static const String kRouteHome = '/home';
  static const String kRouteStoreFormState = '/store_register';
  static const String kRouteSplashScreen = '/splashScreen';
  static const String kRouteNewItemFacilities = '/new_item_facilities';
  static const String kRouteNewItemFacilitiesList = '/new_item_facilities/list';
  static const String kRouteInvoiceDebt = '/invoice_debt';
  static const String kRouteInvoiceDebtForm = '/invoice_debt/form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kRouteAuth:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case kRouteHome:
        return MaterialPageRoute(
            builder: (_) => HomeScreen(settings.arguments));
      case kRouteSplashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case kRouteStoreFormState:
        return MaterialPageRoute(builder: (_) => StoreFormStateScreen());
      case kRouteNewItemFacilities:
        return MaterialPageRoute(builder: (_) => NewItemFacilitiesScreen());
      case kRouteNewItemFacilitiesList:
        return MaterialPageRoute(
            builder: (_) => NewItemFacilitiesListScreen(settings.arguments));
      case kRouteInvoiceDebt:
        return MaterialPageRoute(builder: (_) => InvoiceDebtScreen());

      case kRouteInvoiceDebtForm:
        return MaterialPageRoute(builder: (_) => InvoiceDebtFormScreen());
      default:
        return MaterialPageRoute(builder: (_) => AuthScreen());
    }
  }
}
